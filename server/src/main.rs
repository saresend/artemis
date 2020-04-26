#[macro_use]
extern crate diesel;

#[macro_use]
extern crate serde_derive;

use tokio;
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
    pub len: i32,
    pub timestamp: String,
    pub location_id: i32,
    pub user_id: i32,
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
    use schema::Locations::dsl::*;
    let conn = &*(CONN.lock().unwrap());
    let results = Locations.load::<Location>(conn).unwrap();
    return results;
}

fn create_location(new_loc: &NewLocation) {
    let conn = &*(CONN.lock().unwrap());
    diesel::insert_into(Locations::table).values(new_loc).execute(conn).unwrap();
}

fn get_appointments_for_id(u_id: i32) -> Vec<Appointment> {
    use schema::Appointments::dsl::*;
    let conn: &SqliteConnection = &*(CONN.lock().unwrap());
    let results = Appointments.filter(user_id.eq(u_id)).load::<Appointment>(conn).unwrap();
    return results;
}

fn insert_new_appointment(appt: &NewAppointment) {
    let conn = &*(CONN.lock().unwrap());
    diesel::insert_into(Appointments::table).values(appt).execute(conn).unwrap();
}

fn get_connection() -> SqliteConnection {
    dotenv().ok();
    let db_url = env::var("DATABASE_URL").unwrap();
    SqliteConnection::establish(&db_url).expect("Error connecting")
}

#[tokio::main]
async fn main() {
    let location_path = warp::path("location/").map(|| warp::reply::json(&get_all_locations()));
    let appoint_path =
        warp::path!("appointments" / i32).map(|a| warp::reply::json(&get_appointments_for_id(a)));
    let add_appt_path = warp::post()
        .and(warp::path("appointments/add"))
        .and(warp::body::json())
        .map(|new_apt: NewAppointment| {
            insert_new_appointment(&new_apt);
            warp::reply::reply()
        });

    let add_loc_path = warp::post()
        .and(warp::path("location/new"))
        .and(warp::body::json())
        .map(|new_loc: NewLocation| {
            create_location(&new_loc); 
            warp::reply::reply()
        });

    let post_routes = add_appt_path.or(add_loc_path);

    let routes = post_routes.or(warp::get().and(location_path.or(appoint_path)));
    warp::serve(routes).run(([0, 0, 0, 0], 8000)).await;
}
