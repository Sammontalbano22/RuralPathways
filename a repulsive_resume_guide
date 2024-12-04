""" This is an AI driven resume builder. Put a template resume of your choice where stated. Then, when ran, you will be prompted to enter the applications job description. 
You will need to modify the formatting and file name/ location. This code is highly customizable. """

"""
NOTE: To get the code running you will need to go through and fill out the provided template.
"""


//System Imports

import openai
import os
from fpdf import FPDF
from datetime import datetime


# Retrieve the OpenAI API key from the environment variable
openai.api_key = 'Insert Your API Key Here'


#Insert personal information for header.
class PDF(FPDF):
    def header(self):
        self.set_font('Arial', 'B', 14)
        self.cell(0, 8, 'Your Name Here', align='C', ln=True)
        self.set_font('Arial', '', 10)
        self.cell(0, 6, 'Email: {'Your Email Here' | LinkedIn: {'Your Linkedln Here'}, align='C', ln=True)
        self.cell(0, 6, '| GitHub:  {'Your Github Here'}', align='C', ln=True)
        self.ln(8)

    def section_title(self, title):
        self.set_font('Arial', 'B', 12)
        self.set_text_color(0, 51, 102)
        self.cell(0, 8, title, ln=True)
        self.set_font('Arial', '', 10)
        self.set_text_color(0, 0, 0)
        self.ln(1)

    def add_bullet_point(self, text):
        self.cell(5)
        self.multi_cell(0, 6, f"- {text}")

def update_resume(requirements, resume_content):
    print("Updating resume with the following requirements:")
    print(requirements)
    print("Current resume content:")
    print(resume_content)

    # Use OpenAI API to update the resume content based on the requirements. This is where you can modify the chatbot to better meet your project specifications.
    prompt = f"""You are a professional Software Engineering resume writer. Update the following resume content keeping it to one page in length to highlight how the candidate meets the following job requirements. Only reword what has been provided in the template resume and use all of its content. Do not make stuff up that is not shown in the temmplate:

Job Requirements:
{requirements}

Resume Content:
{resume_content}

Updated Resume Content:
Summary of Changes:"""
    response = openai.chat.completions.create(
        model="gpt-3.5-turbo",  # Updated to the new model API
        messages=[
            {"role": "system", "content": "You are a professional resume writer."},
            {"role": "user", "content": prompt}
        ],
        max_tokens=800,
        temperature=0.7,
    )

    print("Response from OpenAI API:")
    print(response)

    # Extract the updated content and summary of changes from the response
    updated_content = response.choices[0].message.content.strip()
    updated_content_parts = updated_content.split("Summary of Changes:")
    updated_resume_content = updated_content_parts[0].strip()
    summary_of_changes = updated_content_parts[1].strip() if len(updated_content_parts) > 1 else "No changes provided."

    print("Updated resume content:")
    print(updated_resume_content)
    print("Summary of changes:")
    print(summary_of_changes)

    return updated_resume_content, summary_of_changes

def main():
    print("Starting the resume update process")

    # Collect the key qualifications, skills, and requirements from the user
    print("Please enter the key qualifications, skills, and requirements for the job (press Enter twice to finish):")
    requirements = ''
    while True:
        line = input()
        if line:
            requirements += line + '\n'
        else:
            break

    print("Collected job requirements:")
    print(requirements)

    # Existing resume content (as a string)
    resume_content = """





# Education Section
Education:
- Insert your education Information Here

# Technical Skills Section
Technical Skills:
- Insert your Technical Skills Here

# Professional Experience Section
Professional Experience:
- Lead Website Administrator | Donkey Strategies (Jan 2023 - Jul 2024)
    - Designed and managed 15+ farmer websites for AAPP in partnership with the boy next door.

# Projects Section
Projects:
- AI Calendar App (Concept Stage): Designing an intelligent calendar for iOS with Focus and Do Not Disturb modes, tailored for productivity and user needs.

# Achievements Section
Achievements:
- Dean's List (2024)

# Hobbies Section
Hobbies & Interests:
- Golfing | Fishing | Rocket Design | Classic Literature | DIY Engineering Projects | Vinyl Collecting
"""

    # Update the resume content based on the job requirements
    updated_resume_content, summary_of_changes = update_resume(requirements, resume_content)

    # Generate the file name with today's date
    today_date = datetime.today().strftime('%Y-%m-%d')
    file_name = f"Resume_Updated_{today_date}.pdf"
    file_path = f"Your file location here "

    pdf = PDF()
    pdf.add_page()
    pdf.set_font("Arial", size=8)  # Adjust font size to fit content within one page
    pdf.set_auto_page_break(auto=True, margin=15)  # Ensure content fits within one page

    # Add sections and bullet points
    lines = updated_resume_content.split('\n')
    for line in lines:
        if line.startswith('# '):
            pdf.section_title(line[2:])
        elif line.startswith('- '):
            pdf.add_bullet_point(line[2:])
        else:
            pdf.multi_cell(0, 8, line)

    pdf.output(file_path)
    print(f"Updated resume saved to: {file_path}")
    print(f"Summary of changes: {summary_of_changes}")

if __name__ == "__main__":
    main()
