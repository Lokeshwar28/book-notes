import express from "express";
import bodyParser from "body-parser";
import pg from "pg";
import axios from "axios";

const app = express();
const port = 3000;

const db = new pg.Client({
  user: "postgres",
  host: "localhost",
  database: "book_notes",
  password: "Lokesh1234",
  port: 5432,
});
db.connect();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

// Route to display all books
app.get("/", async (req, res) => {
    try {
        const { sort } = req.query;
        const sortOptions = {
            rating: "rating DESC",
            title: "title ASC",
            recency: "read_date DESC"
        };
        const orderBy = sortOptions[sort] || "read_date DESC";

        const result = await db.query(`SELECT * FROM books ORDER BY ${orderBy}`);
        let books = result.rows;

        // Fetch book covers concurrently
        await Promise.all(books.map(async (book) => {
            if (book.isbn) {
                try {
                    const coverUrl = `https://covers.openlibrary.org/b/isbn/${book.isbn}-L.jpg`;
                    await axios.get(coverUrl); // Check if image exists
                    book.cover_url = coverUrl;
                } catch (error) {
                    book.cover_url = "/images/placeholder.jpg"; // Fallback
                }
            } else {
                book.cover_url = "/images/placeholder.jpg";
            }
        }));

        res.render("index.ejs", { books , sort });
    } catch (err) {
        console.log(err);
        res.status(500).send("Error retrieving books.");
    }
});

// Render Add Book Page
app.get("/add", (req, res) => {
    res.render("add.ejs");
});

// Add Book to Database
app.post("/add", async (req, res) => {
    const { title, author, isbn, read_date , rating, notes } = req.body;
    try {
        await db.query(
            "INSERT INTO books (title, author, isbn, read_date , rating, notes) VALUES ($1, $2, $3, $4, $5 ,$6)",
            [title, author, isbn, read_date , rating, notes]
        );
        res.redirect("/");
    } catch (err) {
        console.log(err);
        res.status(500).send("Error adding book.");
    }
});

// Render Edit Book Page
app.get("/edit/:id", async (req, res) => {
    const { id } = req.params;
    console.log(`Fetching book with ID: ${id}`); // Debugging

    try {
        const result = await db.query("SELECT * FROM books WHERE id = $1", [id]);
        console.log(`Query result:`, result.rows); // Debugging

        if (result.rows.length === 0) {  
            res.status(404).send("Book not found");
            return;
        }

        res.render("edit.ejs", { book: result.rows[0] });
    } catch (err) {
        console.error("Error fetching book details:", err);
        res.status(500).send("Error fetching book details.");
    }
});



// Update Book in Database
app.post("/edit/:id", async (req, res) => {
    const { id } = req.params;
    const { title, author, isbn, rating, read_date , notes } = req.body;

    try {
        const result = await db.query(
            "UPDATE books SET title = $1, author = $2, isbn = $3, rating = $4, read_date = $5 , notes = $6 WHERE id = $7 RETURNING *",
            [title, author, isbn, rating, read_date, notes, id]
        );

        if (result.rowCount === 0) {
            res.status(404).send("Book not found or not updated.");
            return;
        }

        res.redirect("/");
    } catch (err) {
        console.log(err);
        res.status(500).send("Error updating book.");
    }
});


// Delete Book from Database
app.post("/delete/:id", async (req, res) => {
    const { id } = req.params;
    try {
        await db.query("DELETE FROM books WHERE id = $1", [id]);
        res.redirect("/");
    } catch (err) {
        console.log(err);
        res.status(500).send("Error deleting book.");
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
