"""
Local SDXL Lightning image generation provider.
Uses ByteDance/SDXL-Lightning with diffusers library.
"""

import os
import time
from pathlib import Path
from typing import Optional, List

import torch

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


class LocalSDXLGenerator(ImageGeneratorBase):
    """Generate images using SDXL Lightning locally."""

    provider = ImageProvider.LOCAL_SDXL

    # Model paths
    MODEL_DIR = Path(os.environ.get("SDXL_MODEL_DIR", "D:/AI-Models/sdxl-lightning"))
    BASE_MODEL = "stabilityai/stable-diffusion-xl-base-1.0"
    LIGHTNING_REPO = "ByteDance/SDXL-Lightning"
    LIGHTNING_LORA = "sdxl_lightning_4step_lora.safetensors"

    def __init__(self):
        self._pipe = None
        self._device = "cuda" if torch.cuda.is_available() else "cpu"

    def is_available(self) -> bool:
        """Check if SDXL Lightning is set up."""
        # Check if LoRA file exists locally or can be downloaded
        lora_path = self.MODEL_DIR / self.LIGHTNING_LORA
        if lora_path.exists():
            return True

        # Check if we have HuggingFace access
        try:
            from huggingface_hub import hf_hub_download
            return True
        except ImportError:
            return False

    def setup(self) -> bool:
        """Download SDXL Lightning LoRA if needed."""
        print(f"Setting up SDXL Lightning in {self.MODEL_DIR}")
        self.MODEL_DIR.mkdir(parents=True, exist_ok=True)

        try:
            from huggingface_hub import hf_hub_download

            # Download LoRA checkpoint (small, ~400MB)
            print(f"Downloading {self.LIGHTNING_LORA}...")
            lora_path = hf_hub_download(
                repo_id=self.LIGHTNING_REPO,
                filename=self.LIGHTNING_LORA,
                local_dir=self.MODEL_DIR
            )
            print(f"Downloaded to: {lora_path}")
            return True

        except Exception as e:
            print(f"Setup failed: {e}")
            return False

    def _load_pipeline(self):
        """Lazy load the pipeline."""
        if self._pipe is not None:
            return

        print(f"Loading SDXL Lightning pipeline on {self._device}...")

        from diffusers import StableDiffusionXLPipeline, EulerDiscreteScheduler
        from huggingface_hub import hf_hub_download

        # Use float16 for GPU, float32 for CPU
        dtype = torch.float16 if self._device == "cuda" else torch.float32

        # Load base SDXL
        print("Loading SDXL base model (this may take a few minutes first time)...")
        self._pipe = StableDiffusionXLPipeline.from_pretrained(
            self.BASE_MODEL,
            torch_dtype=dtype,
            variant="fp16" if self._device == "cuda" else None,
            use_safetensors=True
        )

        # Load Lightning LoRA
        lora_path = self.MODEL_DIR / self.LIGHTNING_LORA
        if not lora_path.exists():
            lora_path = hf_hub_download(
                repo_id=self.LIGHTNING_REPO,
                filename=self.LIGHTNING_LORA
            )

        print("Loading Lightning LoRA...")
        self._pipe.load_lora_weights(str(lora_path))
        self._pipe.fuse_lora()

        # Configure scheduler for Lightning
        self._pipe.scheduler = EulerDiscreteScheduler.from_config(
            self._pipe.scheduler.config,
            timestep_spacing="trailing"
        )

        # Move to device
        self._pipe = self._pipe.to(self._device)

        # Enable memory optimizations
        if self._device == "cuda":
            self._pipe.enable_model_cpu_offload()

        print("Pipeline ready!")

    def generate(
        self,
        prompt: str,
        output_path: Path,
        config: Optional[ImageConfig] = None
    ) -> GeneratedImage:
        """Generate a single image."""
        config = config or ImageConfig()

        self._load_pipeline()

        start_time = time.time()

        # Generate
        generator = None
        if config.seed is not None:
            generator = torch.Generator(device=self._device).manual_seed(config.seed)

        result = self._pipe(
            prompt=prompt,
            negative_prompt=config.negative_prompt,
            width=config.width,
            height=config.height,
            num_inference_steps=config.num_inference_steps,
            guidance_scale=config.guidance_scale,
            generator=generator
        )

        generation_time = time.time() - start_time

        # Save
        output_path = Path(output_path)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        result.images[0].save(output_path)

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


# Register provider
ProviderRegistry.register(ImageProvider.LOCAL_SDXL, LocalSDXLGenerator)
