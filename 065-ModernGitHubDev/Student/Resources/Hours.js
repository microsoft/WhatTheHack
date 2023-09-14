import React from "react";

const Hours = () => {
    // create an array called shelterHours with objects for the shop hours
    // the shelter is open Mon-Fri 10am-4pm and Sat-Sun 9am-8pm
    const shelterHours = [
        { day: "Monday", open: "10am", close: "4pm" },
        { day: "Tuesday", open: "10am", close: "4pm" },
        { day: "Wednesday", open: "10am", close: "4pm" },
        { day: "Thursday", open: "10am", close: "4pm" },
        { day: "Friday", open: "10am", close: "4pm" },
        { day: "Saturday", open: "9am", close: "8pm" },
        { day: "Sunday", open: "9am", close: "8pm" }
    ];

    // determine the current day of the week as a string
    const today = new Date().toLocaleString("en-US", { weekday: "long" });
    // get today's hours from the shelterHours array
    const hours = shelterHours.find(day => day.day === today);

    // display the hours for today
    return (
        <div>
            <h2>Hours</h2>
            <p>
                Today's hours are {hours.open} to {hours.close}.
            </p>
        </div>
    );
};

export default Hours;