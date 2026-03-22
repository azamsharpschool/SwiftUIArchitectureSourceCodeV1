const express = require('express')
const cors = require('cors')
const app = express() 

app.use(cors())

// Movies route
app.get("/api/movies", (req, res) => {

res.set("Cache-Control", "public, max-age=10")

  const movies = [
    { id: 1, title: "Inception 2", year: 2010, rating: 8.8 },
    { id: 2, title: "The Dark Knight", year: 2008, rating: 9.0 },
    { id: 3, title: "Interstellar", year: 2014, rating: 8.6 },
    { id: 4, title: "The Matrix", year: 1999, rating: 8.7 },
    { id: 5, title: "Gladiator", year: 2000, rating: 8.5 },
    { id: 6, title: "Parasite", year: 2019, rating: 8.6 },
    { id: 7, title: "The Shawshank Redemption", year: 1994, rating: 9.3 },
    { id: 8, title: "Avengers: Endgame", year: 2019, rating: 8.4 },
    { id: 9, title: "Whiplash", year: 2014, rating: 8.5 },
    { id: 10, title: "The Social Network", year: 2010, rating: 7.7 }
  ];

  res.json(movies);
});

// Products route
app.get("/api/products", (req, res) => {

  res.set("Cache-Control", "public, max-age=10")

  const products = [
    { id: 1, name: "MacBook Pro 142", category: "Electronics", price: 1999 },
    { id: 2, name: "iPhone 15 Pro", category: "Electronics", price: 999 },
    { id: 3, name: "AirPods Pro", category: "Electronics", price: 249 },
    { id: 4, name: "Nike Running Shoes", category: "Footwear", price: 120 },
    { id: 5, name: "Coffee Maker", category: "Home Appliances", price: 89 },
    { id: 6, name: "Mechanical Keyboard", category: "Accessories", price: 150 },
    { id: 7, name: "Standing Desk", category: "Furniture", price: 450 },
    { id: 8, name: "Gaming Mouse", category: "Accessories", price: 79 },
    { id: 9, name: "Smart Watch", category: "Wearables", price: 299 },
    { id: 10, name: "Backpack", category: "Travel", price: 60 }
  ];

  res.json(products);
});

app.listen(8080, () => {
    console.log('Server is running...')
})