Mix.install([
  {:pythonx, "~> 0.3.0"}
])


Pythonx.uv_init("""
[project]
name = "ppdf"
version = "0.1.0"
description = "Add your description here"
readme = "README.md"
requires-python = ">=3.13"
dependencies = [
    "pdfplumber>=0.11.5",
]
""")


# {_, globals} = Pythonx.eval(
#   """
#   import pdfplumber
#   from itertools import groupby
#   from operator import itemgetter


#   def group_words_into_sentences(words, y_tolerance=3):
#       # Sort words by vertical position (top) and then by horizontal position (x0)
#       sorted_words = sorted(words, key=lambda w: (round(w['top']/y_tolerance)*y_tolerance, w['x0']))

#       # Group words by their vertical position
#       grouped_lines = []
#       for _, line_words in groupby(sorted_words, key=lambda w: round(w['top']/y_tolerance)*y_tolerance):
#           line_words = list(line_words)
#           # Combine words into a sentence
#           sentence = ' '.join(word['text'] for word in line_words)
#           # Get bounding box for the entire sentence
#           if line_words:
#               sentence_info = {
#                   'text': sentence,
#                   'x0': min(w['x0'] for w in line_words),
#                   'x1': max(w['x1'] for w in line_words),
#                   'top': min(w['top'] for w in line_words),
#                   'bottom': max(w['bottom'] for w in line_words)
#               }
#               grouped_lines.append(sentence_info)
#       return grouped_lines

#   print('Python code executed successfully')
#   with pdfplumber.open("document.pdf") as pdf:
#       first_page = pdf.pages[0]

#       words = first_page.extract_words()
#       sentences = group_words_into_sentences(words)

#       for sentence in sentences:
#           print(f"Sentence: {sentence['text']}")
#           print(f"Position: x0={sentence['x0']:.2f}, x1={sentence['x1']:.2f}, top={sentence['top']:.2f}, bottom={sentence['bottom']:.2f}")
#           print("-" * 80)

#   """,
#   %{}
# )


{_, globals} = Pythonx.eval(
  """
  import pdfplumber
  from itertools import groupby
  from operator import itemgetter


  def group_words_into_sentences(words, y_tolerance=3):
      # Sort words by vertical position (top) and then by horizontal position (x0)
      sorted_words = sorted(words, key=lambda w: (round(w['top']/y_tolerance)*y_tolerance, w['x0']))

      # Group words by their vertical position
      grouped_lines = []
      for _, line_words in groupby(sorted_words, key=lambda w: round(w['top']/y_tolerance)*y_tolerance):
          line_words = list(line_words)
          # Combine words into a sentence
          sentence = ' '.join(word['text'] for word in line_words)
          # Get bounding box for the entire sentence
          if line_words:
              sentence_info = {
                  'text': sentence,
                  'x0': min(w['x0'] for w in line_words),
                  'x1': max(w['x1'] for w in line_words),
                  'top': min(w['top'] for w in line_words),
                  'bottom': max(w['bottom'] for w in line_words)
              }
              grouped_lines.append(sentence_info)
      return grouped_lines
  """,
  %{}
)


{result, _} = Pythonx.eval(
  """
  print('Python code executed successfully')
  with pdfplumber.open("document.pdf") as pdf:
      first_page = pdf.pages[0]

      words = first_page.extract_words()
      sentences = group_words_into_sentences(words)

      for sentence in sentences:
          print(f"Sentence: {sentence['text']}")
          print(f"Position: x0={sentence['x0']:.2f}, x1={sentence['x1']:.2f}, top={sentence['top']:.2f}, bottom={sentence['bottom']:.2f}")
          print("-" * 80)

  """,
  globals
)

IO.inspect("Result in elixir")
IO.inspect(result)
