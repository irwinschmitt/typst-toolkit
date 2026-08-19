#import "../templates/banner.typ": banner

#show: banner.with(
  title: "Deep Learning Approaches for Scientific Document Analysis",
  authors: ("Maria Silva", "João Santos", "Ana Oliveira"),
  institution: "Universidade Federal de Exemplo",
  sections: (
    (
      heading: "Introduction",
      content: [
        Scientific document analysis has become increasingly important in the era of digital scholarship. The exponential growth of published research demands automated methods for processing, classifying, and extracting information from scientific texts. In this work, we present a comprehensive approach using deep learning architectures to address these challenges.
      ],
    ),
    (
      heading: "Methodology",
      content: [
        We propose a novel architecture combining transformer models with graph neural networks for structured document understanding. Our pipeline consists of three stages: (1) layout analysis using a fine-tuned detection model, (2) content extraction with a sequence labeling approach, and (3) semantic linking via graph attention networks.
      ],
    ),
    (
      heading: "Results",
      content: [
        Our approach achieves state-of-the-art performance on the DocBank and PubLayNet benchmarks, with F1 scores of 94.2% and 96.1% respectively. The multi-task learning strategy improved extraction accuracy by 3.7% compared to single-task baselines, while reducing inference time by 22%.
      ],
    ),
    (
      heading: "Conclusions",
      content: [
        We demonstrated that combining transformer architectures with graph-based reasoning significantly improves scientific document analysis. Future work will explore cross-lingual transfer and integration with citation knowledge graphs.
      ],
    ),
  ),
)
