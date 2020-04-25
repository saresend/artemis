#[macro_use]
extern crate diesel;

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

#[derive(Queryable)]
pub struct Location {
    pub id: i32,
    pub name: String,
    pub lat: f32,
    pub lng: f32,
}

#[derive(Insertable)]
#[table_name = "Locations"]
pub struct NewLocation {
    pub name: String,
    pub lat: f32,
    pub lng: f32,
}

#[derive(Queryable)]
pub struct User {
    pub id: i32,
    pub email: String,
    pub token: String,
}

#[derive(Insertable)]
#[table_name = "Users"]
pub struct NewUser {
    pub email: String,
    pub token: String,
}

#[derive(Queryable)]
pub struct Appointment {
    pub id: i32,
    pub location_id: i32,
    pub user_id: i32,
    pub len: i32,
    pub timestamp: String,
}

#[derive(Insertable)]
#[table_name = "Appointments"]
pub struct NewAppointment {
    pub location_id: i32,
    pub user_id: i32,
    pub len: i32,
    pub timestamp: String,
}

fn get_connection() -> SqliteConnection {
    dotenv().ok();
    let db_url = env::var("DATABASE_URL").unwrap();
    SqliteConnection::establish(&db_url).expect("Error connecting")
}

fn main() {}
