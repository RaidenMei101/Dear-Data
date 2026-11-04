import java.io.File;

// My 16 anime characters
String[] names = {
  "tenza", "nurugai", "shion", "aza chobei",
  "senta dono", "yuzuriha", "gabimaru", "sagiri",
  "hoko", "mei", "shugen dono", "thoma",
  "fuchi", "gantetsusai", "ju fa", "tao fa"
};

// Each observation has a character and an emotion
String[] characters = new String[25];
String[] emotions = new String[25]; //I created 2 empty arrays for emotions and characters because I have 25 observations, this was done so I EASILY just use their index to access each

// Colour names for the scheme
String[] labels = {
  "Sadness", "Awe", "Fascination", "Frustration",
  "Tension", "Admiration", "Empathy", "Triumph"
};

int[] palette = new int[8];
int count = 0; // Here I create an array called 'palette' so store the 8 emotion category colours, the count is at one because nothing has been loaded, it will increment each time and stop at 25


// SETUP: Runs once when the programme starts
void setup() {
  size(1200, 850, P3D); //'void setup()' loads the visualisation once. The size is my width and height of the window, P3D allows shapes to be 3D

  // One colour for each emotion category
  palette[0] = color(45, 120, 255);
  palette[1] = color(160, 65, 255);
  palette[2] = color(0, 225, 200);
  palette[3] = color(255, 55, 80);
  palette[4] = color(255, 75, 180);
  palette[5] = color(255, 205, 40);
  palette[6] = color(35, 225, 120);
  palette[7] = color(255, 130, 35);

  // Ask the user to select the data file
  selectInput("YOOOO CHOOSE THE CSV GNGGG", "fileSelected");
}


// READ DATA: Loads observations from the spreadsheet
void fileSelected(File file) {
  if (file == null) return; //if the file ain't selected then don't return nothing, cos there aint nothing to return 

  Table data = loadTable(file.getAbsolutePath(), "csv"); //here, my file is loaded and saved in the variable 'data' IN table format as my csv is ordered in rows and columns

  if (data == null || data.getColumnCount() < 6) {
    println("Unable to read CSV");
    return;
  } //here the getcolumncount method reads the ACTUAL amount of columns in the csv so 6, so its saying if there are less than 6 columns, stop reading and print eror message cos its wrong

  count = 0; //I set it to 0 so the program can start counting from the absolute beginning

  // Looks at each row in the CSV
  for (TableRow row : data.rows()) {

    String character = row.getString(3);
    String emotion = row.getString(5); //Here my code goes through EVERY row in my csv and gets the character from column 3 and emotion from column 5, I then store it as strings as its text

    // Ignore rows without character or emotion data
    if (character == null || emotion == null) continue; //It will just continue if there are missing values, rather than the whole code just breaking like that

    character = trim(character);
    emotion = trim(emotion); //I used the 'trim()' method to remove any spaces in the beginning or and end or each character name or emotion so that the possibility of an error later was minimised

    if (character.length() == 0) continue;
    if (emotion.length() == 0) continue; //If a row in the character column has a length of 0 so there's nothing there, it will continue, same with emotion
    if (emotion.equalsIgnoreCase("Emotions")) continue; //Here the word emotions is getting compared to the title Emotions, the method 'equalsIgnoreCase()' ignores any caps and looks at rows BELOW the title

    if (count >= 25) break; //If the count is equal or more than 25 stop the loop, so there are only 25 data points

    characters[count] = character;
    emotions[count] = emotion;

    count++;
  } //These lines save each character and its matching emotion at the same index in separate arrays. Then count++ increases the index by one, so it's ready for the next observation.

  println("Loaded " + count + " observations");
} //Here, I am just checking to see if all my 25 expected obersavtions are being loaded


// DRAW: Displays the observations
void draw() {
  background(9, 12, 27);
  lights();
  noStroke(); //The 'draw()' method displays my sketch 60 times/second, 'lights()' turns on lighting giving my 3D shapes more depth!

  // Repeat once for every observation
  for (int observation = 0; observation < count; observation++) { //This for loop repeats the drawing instructions for each of my 25 observations, starting at index 0 and stopping when all 25 are done

    // Five columns of shapes
    int column = observation % 5; //To find out which column shape goes in
    int row = observation / 5; //To find out which row the shape goes in (BOTH arrange the grid in a 5 x 5)

    int positionX = 130 + column * 220;
    int positionY = 190 + row * 125; //These 2 lines find out the X and Y position for each shape (the multiplication just moves it along evenly)

    String character = characters[observation];
    String emotion = emotions[observation]; //These 2 lines retrieve the character and its matching emotion from the same index in the two arrays.

    // Get the colour and size from the emotion
    int shapeColour = emotionColour(emotion); //This line basically maps the current emotion to the correct colour I defined prior
    float shapeSize = emotionSize(emotion); //This line makes the current emotion the correct size that I defined later  

    pushMatrix(); //Calling 'pushMatrix()' saves the current position and settings so each shape can be drawn separately without affecting others
    
    // Move this observation to its grid position
    translate(positionX, positionY, 0); // 'translate()' actually MOVES the shape to the coordinates we calculcated in the variables 'positionX' and 'positionY'. 0 is for 3D depth, we don't want to change that

    fill(shapeColour); //'fill()' method fills the shape in the colour that we just mapped for each emotion

    // Display the character or both characters
    drawCharacters(character, shapeSize);

    popMatrix(); //This restores the previous coordinates so the next shape isn't affected
  }

  // Title positioning
  fill(255);
  textAlign(CENTER);
  textSize(28);
  text("DEAR DATA: ANIME EMOTIONS", width / 2, 45);

  // Display the emotion colour scheme, the emotion names, and the boxes of colour
  textAlign(LEFT);
  textSize(12);

  for (int category = 0; category < 8; category++) { //for loop starts at 0 and loops until all 8 categories are done, each time it's looped, the category counter is incremented by 1
    int positionX = 20 + category * 145; //

    fill(palette[category]); //'fill()' method uses the colour legend from 'palette' to colour each emotion's rectangle
    rect(positionX, 95, 12, 12); //Coloured rectangles sizing and positioning

    fill(235);
    text(labels[category], positionX + 18, 106); // Positioning of the emotion name to the right of the coloured rectangle
  }
}

// DRAW CHARACTERS
void drawCharacters(String characterText, float shapeSize) { //This method receives a character's name and a shape size, then uses them to draw the character's shape.
