## Dataset

The images are **not included in this repository**. They are stills of the *Game of Thrones* series and were collected from public Kaggle datasets, so they are not redistributed here. According to the project report, two datasets of character images were merged and only the six characters present in both were kept.

### Expected layout

The notebooks read the images from a Google Drive folder with one subfolder per character, split into `Train` and `Test`:

```
imagenes/
├── Train/
│   ├── Arya Stark/              (187 images)
│   ├── Daenerys Targaryen/      (187)
│   ├── Jaime Lannister/         (187)
│   ├── John Snow/               (187)
│   ├── Sansa Stark/             (187)
│   └── Tyrion Lannister/        (187)
└── Test/
    ├── Arya Stark/              (102)
    ├── Daenerys Targaryen/      (37)
    ├── Jaime Lannister/         (56)
    ├── John Snow/               (86)
    ├── Sansa Stark/             (67)
    └── Tyrion Lannister/        (58)
```

Images are JPG or PNG; the notebooks resize them to 150×150 RGB when loading. In the notebooks the folder path is set in the `path` field of the *Acceder al Drive* cell.
