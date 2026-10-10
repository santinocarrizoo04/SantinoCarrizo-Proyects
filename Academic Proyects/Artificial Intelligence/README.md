## Overview

A convolutional neural network (ConvNet) that identifies which of six *Game of Thrones* characters appears in a face image: Arya Stark, Daenerys Targaryen, Jaime Lannister, Jon Snow, Sansa Stark and Tyrion Lannister. The goal was to study how architecture and training choices affect generalization, so the model was trained and compared across 10 experiments.

This is a team project (group of 6) for the *Artificial Intelligence* course (Intelligent Systems) at UTN FRBA. The notebooks start from the course's ConvNet demo notebook (parametrized Colab forms); the dataset consolidation, the experiments and the analysis are the team's work.

### Technologies

- **Languages:** Python
- **Libraries:** TensorFlow / Keras, scikit-learn (metrics), NumPy, Pandas, Matplotlib, Pillow, OpenCV, ipywidgets
- **Platform:** Google Colab
- **Tooling note:** Google Gemini was used as a coding assistant, as disclosed in the project report.

### Key Components

**Data:**
- 1,122 training images (187 per character, balanced) and 406 test images (102 / 37 / 56 / 86 / 67 / 58 per character, in alphabetical order of the characters)
- Images resized to 150×150 RGB
- According to the project report, two public Kaggle datasets were merged, keeping the six characters present in both (see [`data/`](data/README.md))

**Model:**
- ConvNet built with Keras: 3–4 `Conv2D` + `MaxPooling` blocks (ReLU), `Flatten`, one or two dense layers with Batch Normalization and Dropout (0.4), and a softmax output over the 6 classes
- Data augmentation layers active only during training: horizontal flip, small translation, rotation, zoom, contrast and brightness
- Training with backpropagation for up to 200 epochs, 10% of the training set used for validation, Early Stopping (monitoring starts at epoch 100, patience of 25 epochs, best weights restored)
- Evaluation with per-class precision, recall and F1-score, and confusion matrices, on both training and test data

### Experiments

All runs use 150×150×3 inputs, 2×2 max pooling and Dropout 0.4. Accuracies come from the classification reports saved in each notebook.

| Run | Conv layers | Kernel | Dense layers | Optimizer | Learning rate | Train acc. | Test acc. |
|----:|:-----------:|:------:|:-------------|:----------|:-------------:|:----------:|:---------:|
| 1  | 3 | 3×3 | 1024 + BN + Dropout            | Adam     | 0.001  | 88% | 59% |
| 2  | 3 | 3×3 | 1024 + BN + Dropout            | Nadam    | 0.001  | 90% | 53% |
| 3  | 3 | 3×3 | 1024 + BN + Dropout            | Momentum | 0.001  | 50% | 36% |
| 4  | 3 | 3×3 | 512 + BN + Dropout + 256       | Adam     | 0.0005 | 91% | 57% |
| 5  | 4 | 3×3 | 512 + BN + Dropout + 256       | Adam     | 0.0005 | 89% | 60% |
| 6  | 4 | 3×3 | 256 + BN + Dropout             | Adam     | 0.0003 | 52% | 38% |
| 7  | 3 | 5×5 | 1024 + BN + Dropout            | Adam     | 0.001  | 92% | **61%** |
| 8  | 4 | 5×5 | 1024 + BN + Dropout            | Adam     | 0.001  | 77% | 56% |
| 9  | 3 | 5×5 | 1024 + BN + Dropout + 512 + BN + Dropout | Adam | 0.001 | 81% | 56% |
| 10 | 3 | 5×5 | 1024 + BN + Dropout            | Adam     | 0.0005 | 89% | 60% |

### Findings

- **Overfitting is the main issue.** The best configurations reach roughly 90% on the training set but only 53–61% on unseen images. For reference, always predicting the most frequent class would score about 25% on the test set.
- **Adam with 5×5 kernels (run 7) generalized best**, with 61% test accuracy. Adam also beat Nadam and Momentum under the same architecture (runs 1–3).
- **Two configurations underfit** (runs 3 and 6, around 50% on training data), so the issue there was learning speed rather than memorization.
- According to the project report, Tyrion Lannister was the hardest character to classify, likely because of the variety of lighting, poses and backgrounds in his images.

## Repository Structure

```
Artificial Intelligence/
├── notebooks/   # 10 training runs (ConvNet-procesar-imagenes-corrida-1 … 10)
└── data/        # dataset description and expected folder layout
```

## Getting Started

The notebooks run in Google Colab and mount Google Drive to read the images:

1. Download the dataset (see [`data/README.md`](data/README.md)) and place it in your Drive.
2. Open a notebook in Colab and set the `path` field of the *Acceder al Drive* cell to your images folder.
3. Run the cells sequentially: load images, prepare data, build the model, train, and evaluate on the training and test sets.
