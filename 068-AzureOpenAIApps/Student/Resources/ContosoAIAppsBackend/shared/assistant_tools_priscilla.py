from shared.assistant_tools import serialize_assistant_response
from shared.cosmos_db_utils import CosmosDbUtils


def v_retrieve_guest_activity_preferences_and_requests(customer_email: str) -> str:
    result = retrieve_guest_activity_preferences_and_requests(customer_email)
    return serialize_assistant_response(result)


def v_guest_has_activity_preferences_and_requests(customer_email: str) -> str:
    result = guest_has_activity_preferences_and_requests(customer_email)
    return serialize_assistant_response(result)


def v_list_available_activities() -> str:
    result = list_available_activities()
    return serialize_assistant_response(result)


def guest_has_activity_preferences_and_requests(customer_email: str) -> bool:
    return retrieve_guest_activity_preferences_and_requests(customer_email) is not None


def retrieve_guest_activity_preferences_and_requests(customer_email: str) -> object | None:
    cosmos_util = CosmosDbUtils("activitypreferences")

    query = "SELECT * FROM a WHERE a.registrationId = '{}'".format(customer_email)

    retrieval_response = cosmos_util.query_container(query, enable_cross_partition_query=True)

    for item in retrieval_response:

        response = {
            "profileIdentifier": item["profileId"],
            "registrationId": item["registrationId"],
            "guest_email_address": item["guest_email_address"],
            "guest_full_name": item["guest_full_name"],
            "signature_date": item["signature_date"],
            "preferred_activities": item["activity_preferences"],
            "activity_reservation_requests": item['activity_requests']
        }

        return response

    return None


def list_available_activities():
    results = [
        {
            "activityName": "Contoso Floating Museums",
            "activityDescription": "Embark on a captivating journey through time aboard our floating marvels, "
                                   "where each exhibit showcases the wonders of human achievement against the "
                                   "backdrop of the endless sea. From ancient maritime civilizations to futuristic "
                                   "technologies, immerse yourself in the ever-evolving saga of human ingenuity. "
                                   "Discover artifacts, stories, and interactive displays that illuminate the rich "
                                   "tapestry of our maritime heritage. Step aboard and let the waves of inspiration "
                                   "carry you through the corridors of history at Contoso Floating Museums"
        },
        {
            "activityName": "Contoso Solar Yachts",
            "activityDescription": "Step aboard Contoso Solar Yachts for a voyage like no other, where luxury meets "
                                   "sustainability on the high seas. Set sail on our state-of-the-art solar-powered "
                                   "vessels, gliding gracefully through azure waters while leaving only gentle "
                                   "ripples in our wake. Bask in the opulence of our meticulously crafted interiors, "
                                   "where every detail reflects elegance and comfort. As you soak in the panoramic "
                                   "views, powered by the sun's rays, indulge in gourmet cuisine and personalized "
                                   "service that redefine the meaning of luxury cruising"
        },
        {
            "activityName": "Contoso Beachfront Spa",
            "activityDescription": "Welcome to Contoso Beachfront Spa, where tranquility meets the tide in a haven of "
                                   "relaxation and rejuvenation. Nestled along the pristine shores, our sanctuary "
                                   "oIers a serene escape from the bustle of everyday life. Surrender to the gentle "
                                   "rhythm of the waves as our expert therapists pamper you with bespoke treatments "
                                   "designed to renew body, mind, and soul. From soothing massages to invigorating "
                                   "facials, each experience is tailored to your individual needs, ensuring a journey "
                                   "to total bliss. Let the ocean breeze caress your senses as you unwind in our "
                                   "luxurious facilities, complete with seaside vistas and indulgent amenities. "
                                   "Discover the ultimate oasis of serenity at Contoso Beachfront Spa, where every "
                                   "moment is a tide of tranquility"
        },
        {
            "activityName": "Contoso Dolphin and Turtle Tour",
            "activityDescription": "Dive into adventure at Contoso Dolphin and Turtle Tour, where the wonders of the "
                                   "ocean await! Nestled in a tropical paradise, our water park invites you to embark "
                                   "on an unforgettable journey filled with excitement and discovery. Join our "
                                   "playful dolphin and turtle companions as you glide down winding slides and splash "
                                   "into crystal-clear pools. Explore interactive exhibits that celebrate marine life "
                                   "and conservation, offering insights into the beauty and diversity of our "
                                   "underwater world. With thrilling rides, family-friendly attractions, "
                                   "and refreshing aquatic fun, Contoso Dolphin and Turtle Tour promises a splashing "
                                   "good time for adventurers of all ages. Come make a splash and create memories "
                                   "that will last a lifetime!"
        }
    ]

    return results
