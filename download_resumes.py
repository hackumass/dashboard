import csv
import argparse
import requests
import os

# Before running this script, run the SQL below (e.g., with heroku psql) to export database info to CSV.

# To load a list of RSVPs for this script:
# \copy (select name, resume_file_name, education_lvl from event_applications e left join users u on u.id=e.user_id where u.rsvp=true) to 'resume_urls.csv' delimiter ',' csv header;

# To load a list of checked in users for this script:
# \copy (select name, resume_file_name, education_lvl from event_applications e left join users u on u.id=e.user_id where u.check_in=true) to 'resume_urls.csv' delimiter ',' csv header;

p = argparse.ArgumentParser(description='Download resumes for participants, sorted into folders by class year, given a csv export.')
p.add_argument('csv_file', help='CSV file containing the following rows in order: name, resume_file_name, and education_lvl (from the users table).')
p.add_argument('--azure-storage-acct', help='the Azure blob storage account')
p.add_argument('--azure-container-name', help='the Azure blob container name')
p.add_argument('--custom-blob-path', help='The full URL to the blob path used for Dashboard. If unset, use --azure-storage-acct and --azure-container-name; the blob path is https://[azure_storage_acct].blob.core.windows.net/[azure_container_name]', default=None)
args = p.parse_args()

blob_path = args.custom_blob_path or 'https://{}.blob.core.windows.net/{}'.format(args.azure_storage_acct, args.azure_container_name)

if not args.custom_blob_path and not args.azure_storage_acct and not args.azure_container_name:
    print('Need to specify either --custom-blob-path OR --azure-storage-acct and --azure-container-name')
    exit(1)

print('Blob path:', blob_path)
reader = csv.reader(open(args.csv_file))
next(reader)

if os.path.exists('resumes_out/'):
    print('resumes_out folder already exists. Delete it before running the script.')
    exit(1)

os.mkdir('resumes_out')
for line in reader:
    print('Downloading', line)
    folder_name = line[2].title()
    # replace '/' with '_' in folder name
    folder_name = folder_name.replace('/', '_')
    if not os.path.exists('resumes_out/{}'.format(folder_name)):
        os.mkdir('resumes_out/{}'.format(folder_name))
    r = requests.get('{}/resume/{}'.format(blob_path, line[1]), allow_redirects=True)
    if r.status_code != 404:
        open('resumes_out/{}/{}.pdf'.format(folder_name, line[0].title()), 'wb').write(r.content)
    else:
        print('No resume for', line[0], '(HTTP 404)')
# To ensure there are no 404's that were saved, run:
# grep -Z -lr 'BlobNotFound' resumes_out/|gxargs -d '\n' rm
# (replace gxargs with xargs on Linux)
