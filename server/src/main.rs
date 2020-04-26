#[macro_use]
extern crate diesel;

#[macro_use]
extern crate serde_derive;

use warp::Filter;

mod schema;
use crate::schema::*;
use diesel::prelude::*;
use diesel::sqlite::SqliteConnection;
use dotenv::dotenv;
use lazy_static::lazy_static;
use std::env;
use std::sync::Mutex;

lazy_static! {
    static ref CONN: Mutex<SqliteConnection> = Mutex::new(get_connection());
}

#[derive(Queryable, Serialize)]
pub struct Location {
    pub id: i32,
    pub name: String,
    pub lat: f32,
    pub lng: f32,
}

#[derive(Insertable, Deserialize)]
#[table_name = "Locations"]
pub struct NewLocation {
    pub name: String,
    pub lat: f32,
    pub lng: f32,
}

#[derive(Queryable, Serialize)]
pub struct User {
    pub id: i32,
    pub email: String,
    pub token: String,
}

#[derive(Insertable, Deserialize)]
#[table_name = "Users"]
pub struct NewUser {
    pub email: String,
    pub token: String,
}

#[derive(Queryable, Serialize)]
pub struct Appointment {
    pub id: i32,
    pub location_id: i32,
    pub user_id: i32,
    pub len: i32,
    pub timestamp: String,
}

#[derive(Insertable, Deserialize)]
#[table_name = "Appointments"]
pub struct NewAppointment {
    pub location_id: i32,
    pub user_id: i32,
    pub len: i32,
    pub timestamp: String,
}

fn get_all_locations() -> Vec<Location> {
    todo!()
}

fn get_appointments_for_token(token: String) -> Vec<Appointment> {
    todo!()
}

fn insert_new_appointment(appt: &NewAppointment) {
    todo!()
}

fn get_connection() -> SqliteConnection {
    dotenv().ok();
    let db_url = env::var("DATABASE_URL").unwrap();
    SqliteConnection::establish(&db_url).expect("Error connecting")
}

fn main() {
    let location_path = warp::path("location/").map(|| warp::reply::json(&get_all_locations()));

    let routes = warp::get().and(location_path);
    warp::serve(routes).run(([0, 0, 0, 0], 8000));
}
