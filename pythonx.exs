Mix.install([
  {:pythonx, "~> 0.3.0"}
])

Pythonx.uv_init("""
[project]
name = "project"
version = "0.0.0"
requires-python = "==3.10.*"
dependencies = [
  "mlx-vlm == 0.1.14",
  "transformers @ git+https://github.com/huggingface/transformers@v4.49.0-SmolVLM-2-release",
  "torch == 2.6.0",
  "num2words == 0.5.14"
]
""")

Pythonx.eval(
  """
  import mlx.core as mx
  from mlx_vlm import load, generate
  from mlx_vlm.prompt_utils import apply_chat_template
  from mlx_vlm.utils import load_config

  # Load the model
  model_path = "mlx-community/SmolVLM2-500M-Video-Instruct-mlx"
  model, processor = load(model_path)
  config = load_config(model_path)

  # Prepare input
  image = ["http://images.cocodataset.org/val2017/000000039769.jpg"]
  prompt = "Describe this image."

  # Apply chat template
  formatted_prompt = apply_chat_template(
      processor, config, prompt, num_images=len(image)
  )

  # Generate output
  output = generate(model, processor, formatted_prompt, image, verbose=False)
  print(output)
  """,
  %{}
)
