from urllib.request import urlretrieve, URLError

uri_fmt = 'https://portalstoragewuprod.azureedge.net/vision/{}/{}.jpg'
file_fmt = '{}_{}.jpg'

for service in ['Analysis', 'Thumbnail']:
    for ix in range(1, 40):
        uri = uri_fmt.format(service, ix)
        img = file_fmt.format(service, ix)
        try:
            urlretrieve(uri, img)
            print('Downloaded {} to {}'.format(uri, img))
        except URLError as e:
            print('Image {} failed to download: {}'.format(uri, e))
