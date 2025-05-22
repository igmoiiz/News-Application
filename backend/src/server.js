const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const bodyParser = require("body-parser");
const News = require("./Model/news_model");

const app = express();
app.use(express.json());
app.use(cors());

const PORT = 5000;

mongoose
  .connect(
    "mongodb+srv://itxarrehman:Xlimpro&85@cluster0.lznyvr2.mongodb.net/News"
  )
  .then(() => {
    console.log("Connected to MongoDB");

    //  Get Route
    app.get("/api", (req, res) => {
      res.send({ message: "Hello World" });
    });

    //    Get News Articles
    app.get("/api/news", async (req, res) => {
      try {
        const news = await News.find();
        res.status(200).json(news);
      } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Internal Server Error" });
      }
    });

    //    Post route for News
    app.post("/api/news/post", async (req, res) => {
      try {
        const {
          title,
          description,
          imageUrl,
          postedByEmail,
          postedByName,
          createdAt,
        } = req.body;
        const newArticle = new News({
          title,
          description,
          imageUrl,
          postedByEmail,
          postedByName,
          createdAt,
        });
        newArticle.save();
        res.status(201).json(newArticle);
      } catch (error) {
        console.error(error.message);
        res.status(500).json({ error: "Internal Server Error" });
      }
    });

    //  ==================================END ROUTES======================
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server is running on port ${PORT}`);
});
