"""
API-based image generation providers.
Supports OpenAI DALL-E, Replicate, Stability AI, etc.
"""

import os
import time
import base64
from pathlib import Path
from typing import Optional, List


# ============================================================
# LIBRARY-FIRST PROTOCOL
# ============================================================
# Before generating code, check:
#   1. .claude/library/catalog.json
#   2. .claude/docs/inventories/LIBRARY-PATTERNS-GUIDE.md
#   3. D:\Projects\* for existing implementations
#
# Decision: REUSE (>90%) | ADAPT (70-90%) | FOLLOW pattern | BUILD new
# ============================================================

try:
    from .base import (
        ImageGeneratorBase,
        ImageProvider,
        ImageConfig,
        GeneratedImage,
        ProviderRegistry
    )
except ImportError:
    from base import (
        ImageGeneratorBase,
        ImageProvider,
        ImageConfig,
        GeneratedImage,
        ProviderRegistry
    )


class OpenAIGenerator(ImageGeneratorBase):
    """Generate images using OpenAI DALL-E 3."""

    provider = ImageProvider.OPENAI

    def __init__(self):
        self._client = None
        self._api_key = os.environ.get("OPENAI_API_KEY")

    def is_available(self) -> bool:
        """Check if OpenAI API key is set."""
        return self._api_key is not None

    def setup(self) -> bool:
        """Verify OpenAI API access."""
        if not self._api_key:
            print("OPENAI_API_KEY environment variable not set")
            return False

        try:
            from openai import OpenAI
            self._client = OpenAI(api_key=self._api_key)
            return True
        except ImportError:
            print("openai package not installed. Run: pip install openai")
            return False

    def generate(
        self,
        prompt: str,
        output_path: Path,
        config: Optional[ImageConfig] = None
    ) -> GeneratedImage:
        """Generate image using DALL-E 3."""
        config = config or ImageConfig()

        if self._client is None:
            self.setup()

        from openai import OpenAI
        if self._client is None:
            self._client = OpenAI(api_key=self._api_key)

        start_time = time.time()

        # Map size to DALL-E supported sizes
        size = "1024x1024"
        if config.width == 1792 and config.height == 1024:
            size = "1792x1024"
        elif config.width == 1024 and config.height == 1792:
            size = "1024x1792"

        response = self._client.images.generate(
            model="dall-e-3",
            prompt=prompt,
            size=size,
            quality="standard",
            n=1,
            response_format="b64_json"
        )

        generation_time = time.time() - start_time

        # Save image
        output_path = Path(output_path)
        output_path.parent.mkdir(parents=True, exist_ok=True)

        image_data = base64.b64decode(response.data[0].b64_json)
        with open(output_path, "wb") as f:
            f.write(image_data)

        return GeneratedImage(
            path=output_path,
            prompt=prompt,
            provider=self.provider,
            config=config,
            generation_time_seconds=generation_time
        )

    def generate_batch(
        self,
        prompts: List[str],
        output_dir: Path,
        config: Optional[ImageConfig] = None
    ) -> List[GeneratedImage]:
        """Generate multiple images."""
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)

        results = []
        for i, prompt in enumerate(prompts):
            output_path = output_dir / f"image_{i+1}.png"
            result = self.generate(prompt, output_path, config)
            results.append(result)
            print(f"Generated {i+1}/{len(prompts)}: {output_path}")

        return results


class ReplicateGenerator(ImageGeneratorBase):
    """Generate images using Replicate API."""

    provider = ImageProvider.REPLICATE

    # Default to SDXL Lightning on Replicate
    MODEL = "bytedance/sdxl-lightning-4step:727e49a643e999d602a896c774a0658ffefea21465756a6ce24b7ea4165ber0c"

    def __init__(self):
        self._client = None
        self._api_key = os.environ.get("REPLICATE_API_TOKEN")

    def is_available(self) -> bool:
        """Check if Replicate API key is set."""
        return self._api_key is not None

    def setup(self) -> bool:
        """Verify Replicate API access."""
        if not self._api_key:
            print("REPLICATE_API_TOKEN environment variable not set")
            return False

        try:
            import replicate
            return True
        except ImportError:
            print("replicate package not installed. Run: pip install replicate")
            return False

    def generate(
        self,
        prompt: str,
        output_path: Path,
        config: Optional[ImageConfig] = None
    ) -> GeneratedImage:
        """Generate image using Replicate."""
        config = config or ImageConfig()

        import replicate
        import urllib.request

        start_time = time.time()

        output = replicate.run(
            self.MODEL,
            input={
                "prompt": prompt,
                "width": config.width,
                "height": config.height,
                "num_inference_steps": config.num_inference_steps,
            }
        )

        generation_time = time.time() - start_time

        # Download and save
        output_path = Path(output_path)
        output_path.parent.mkdir(parents=True, exist_ok=True)

        if isinstance(output, list) and len(output) > 0:
            urllib.request.urlretrieve(output[0], output_path)

        return GeneratedImage(
            path=output_path,
            prompt=prompt,
            provider=self.provider,
            config=config,
            generation_time_seconds=generation_time
        )

    def generate_batch(
        self,
        prompts: List[str],
        output_dir: Path,
        config: Optional[ImageConfig] = None
    ) -> List[GeneratedImage]:
        """Generate multiple images."""
        output_dir = Path(output_dir)
        output_dir.mkdir(parents=True, exist_ok=True)

        results = []
        for i, prompt in enumerate(prompts):
            output_path = output_dir / f"image_{i+1}.png"
            result = self.generate(prompt, output_path, config)
            results.append(result)
            print(f"Generated {i+1}/{len(prompts)}: {output_path}")

        return results


# Register providers
ProviderRegistry.register(ImageProvider.OPENAI, OpenAIGenerator)
ProviderRegistry.register(ImageProvider.REPLICATE, ReplicateGenerator)
