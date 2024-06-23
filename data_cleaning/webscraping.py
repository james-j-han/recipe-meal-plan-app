# this code formats the url since the original data file has bad links
# then it visits those links and scrapes the nutrition data
# then based on the conditions set, some entries are dropped, while others are written in
# this is done via pandas, and then reformatted back to json
import json
import pandas as pd
import requests
from bs4 import BeautifulSoup

def format_url(recipe):
    """
    Formats the URL of a recipe to the desired format.
    
    Args:
    - recipe (dict): A dictionary representing a recipe with a 'url' field.
    
    Returns:
    - str: The formatted URL of the recipe.
    """
    base_url = "https://www.allrecipes.com/recipe/"
    
    try:
        # Extract the recipe ID from the URL (assuming last part is the ID)
        url_parts = recipe['url'].strip('/').split('/')
        recipe_id = url_parts[-1]  # Get the last part of the URL
        
        # Get the title and replace spaces with hyphens
        title = recipe['title'].replace(' ', '-').replace(',', '').lower()
        
        # Construct the formatted URL
        formatted_url = f"{base_url}{recipe_id}/{title}/"
        
        return formatted_url
    
    except KeyError:
        return None
    except Exception as e:
        return None

def get_nutrition_info(url):
    """
    Fetch nutrition information from the recipe URL.
    
    Args:
    - url (str): The URL of the recipe.
    
    Returns:
    - dict: A dictionary containing the extracted nutrition information.
    """
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raise exception for bad status codes

        soup = BeautifulSoup(response.content, 'html.parser')
        nutrition_data = {}

        # Find nutrition table
        nutrition_table = soup.find('table', class_='mm-recipes-nutrition-facts-summary__table')
        if nutrition_table:
            rows = nutrition_table.find_all('tr', class_='mm-recipes-nutrition-facts-summary__table-row')
            for row in rows:
                cells = row.find_all('td', class_='mm-recipes-nutrition-facts-summary__table-cell')
                if len(cells) == 2:
                    label = cells[1].text.strip()
                    value = cells[0].text.strip()
                    if label == 'Calories':
                        nutrition_data['calories'] = value
                    elif label == 'Fat':
                        nutrition_data['fat'] = value
                    elif label == 'Carbs':
                        nutrition_data['carbs'] = value
                    elif label == 'Protein':
                        nutrition_data['protein'] = value
                else:
                    continue
        else:
            return {}

        return nutrition_data

    except requests.exceptions.RequestException as e:
        return {}
    except Exception as e:
        return {}

def main():
    json_file = 'C:/Users/Raya/MAD-Project1/data_cleaning/formatted_recipe_data.json'

    attempted_count = 0
    completed_count = 0

    try:
        with open(json_file, 'r') as f:
            recipes = json.load(f)
    except FileNotFoundError:
        return
    except json.JSONDecodeError as e:
        return

    updated_recipes = []
    for recipe in recipes:
        attempted_count += 1
        url = recipe.get('url', '').strip()
        title = recipe.get('title', '').strip()

        if not url or not title:
            continue

        # Format the URL
        formatted_url = format_url(recipe)
        if not formatted_url:
            continue  # Skip to next recipe if URL formatting fails
        
        # Fetch nutrition info
        nutrition_info = get_nutrition_info(formatted_url)
        if nutrition_info:
            recipe.update(nutrition_info)  # Update recipe dictionary with nutrition info
            recipe['url'] = formatted_url  # Update the URL to the formatted one
            updated_recipes.append(recipe)
            completed_count += 1

    if updated_recipes:
        # Write back updated recipes to the JSON file
        with open(json_file, 'w') as f:
            json.dump(updated_recipes, f, indent=4)

    print(f"Attempted to process {attempted_count} recipes.")
    print(f"Successfully updated {completed_count} recipes.")

    json_file = 'C:/Users/Raya/MAD-Project1/data_cleaning/formatted_recipe_data.json'
    df = pd.read_json(json_file)
    df.dropna(inplace=True)
    if 'url' in df.columns:
        df = df[~df['url'].str.contains('nophoto', na=False)]
    if 'calorie' not in df.columns:
        df['calorie'] = '--'
    if 'protein' not in df.columns:
        df['protein'] = '--'
    if 'fat' not in df.columns:
        df['fat'] = '--'
    if 'carb' not in df.columns:
        df['carb'] = '--'
    


if __name__ == "__main__":
    main()