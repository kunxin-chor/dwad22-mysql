const express = require('express');
const cors = require('cors');

// Use the /promise version because we want to use await/async
const mysql2 = require('mysql2/promise');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

async function main() {

    // use mysql2 to create a connection to the MySQL database
    const connection = await mysql2.createConnection({
        'host': process.env.DB_HOST,
        'user': process.env.DB_USER,
        'database': process.env.DB_DATABASE,
        'password': process.env.DB_PASSWORD
    })

    // rules for naming endpoints in a RESTFul API
    // the idea we are accessing RESOURCES: think of it terms like `files`
    // all endpoints must be nouns ('things')
    
    app.get('/',(req,res) => {
        res.json({
            "message":"Hello world"
        })
    })

    app.get('/artists/' , async (req,res)=>{
        // connection.execute allows us to send a SQL command to the database
        // const results =await connection.execute(`SELECT * FROM Artist`);
        // the actual rows returned by the query is in the first index of the results array
        // res.send(results[0]);

        // but people don't like to put [0] all the time 
        // we use array destructing to avoid having to put [0]
        const [artists] = await connection.execute(`SELECT * FROM Artist`);
        // => const [artists] = [<all the rows>, <meta data>]
        res.json(artists);
    });

    app.get("/employees", async (req,res)=>{
        // do a search engine in MySQL
        
        // we start with a query that always return all the employees
        let query = "SELECT * FROM Employee WHERE 1";

        if (req.query.firstName) {
            query += ` AND firstName LIKE "${req.query.firstName}"`
        }

        if (req.query.lastName) {
            query += ` AND lastName LIKE "${req.query.lastName}"`;
        }
        console.log("query =", query);
        const [employees] = await connection.execute(query);
        res.json(employees);
    });

    app.post("/artists", async (req,res)=>{
        // assuming the artist name should be req.body.name
        const {name} = req.body;
        const query = `INSERT INTO Artist (Name) VALUES ("${name}");`;
        const [results] = await connection.execute(query);
        res.json(results.insertId);
    });

    app.post('/ablums', async (req,res)=>{
        // we need to make sure the artist exists
        // connection.execute with a SELECT will always return an array
        const [artists] = await connection.execute(`SELECT * FROM Artist WHERE ArtistId = "${req.body.artistId}"`);
        // if the artist exists
        if (artists.length > 0) {
            const query = `INSERT INTO Album (Title, ArtistId) VALUES ("${req.body.title}", "${req.body.artistId}");`
            const [results] = await connection.execute(query);
            res.json({
                'insertId': results.insertId
            })
        } else {
            res.status(400); // 400 is bad request
            res.json({
                "message":"ArtistId does not exists"
            })
        }
    });

    app.post("/playlists", async (req,res)=>{
        const [results] = await connection.execute(
            `INSERT INTO Playlist (Name) VALUES ("${req.body.name}");`
        )
        const newPlayListId = results.insertId;

        // assuming req.body.trackIds is an array:
        // {
        //     trackIds: [4,5,6]
        // }

        const trackIdStrings = req.body.trackIds.join(",")
        // Make sure all the track IDs exists
        const trackQuery = `SELECT * FROM Track WHERE TrackId in (${trackIdStrings})`;
        const [trackResults] = await connection.execute(trackQuery);
      
        const insertTrackResults = [];
        // make sure that all the trackIds are valid
        if (trackResults.length === req.body.trackIds.length) {
            // we can start inserting
            for (let trackId of req.body.trackIds) {
                const insertQuery = `
                INSERT INTO PlaylistTrack (PlaylistId, TrackId)
                    VALUES(${newPlayListId}, ${trackId});
                `
                const [results] = await connection.execute(insertQuery);
                insertTrackResults.push(results);
            }
            res.json(insertTrackResults);
        } else {
            res.status(400);
            res.json({
                "error":"One or more of the TrackIds is invalid"
            })
        }
   
    });
}





main();

app.listen(3000, function(req,res){
    console.log("Server has started")
})