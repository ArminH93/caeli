
class Condition {
  int id;
  String description;

  Condition(this.id, this.description);

  String getAssetString() {
    // thunderstorm
    if (id >= 200 && id <= 299)
      return "images/flash.png";
    // drizzle
    else if (id >= 300 && id <= 399)
      return "images/drop.png";
    // rain
    else if (id >= 500 && id <= 599)
      return "images/rain.png";
    // snow
    else if (id >= 600 && id <= 699)
      return "images/snowflake.png";
    // clear sky
    else if (id == 800)
      return "images/sunny.png";
    // sunny
    else if (id == 801)
      return "images/sunny.png";
    // clouds
    else if (id == 802)
      return "images/clouds.png";

    else if (id == 803 || id == 804)
      return "images/clouds.png";

    print("Unknown condition ${id}");
    return "images/umbrella.png";
  }
}