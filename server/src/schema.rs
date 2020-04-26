table! {
    Appointments (id) {
        id -> Integer,
        len -> Integer,
        timestamp -> Text,
        location_id -> Integer,
        user_id -> Integer,
    }
}

table! {
    Locations (id) {
        id -> Integer,
        name -> Text,
        lat -> Float,
        lng -> Float,
    }
}

table! {
    Users (id) {
        id -> Integer,
        email -> Text,
        token -> Text,
    }
}

joinable!(Appointments -> Locations (location_id));
joinable!(Appointments -> Users (user_id));

allow_tables_to_appear_in_same_query!(Appointments, Locations, Users,);
