function extractMp3Metadata(file) {
  return new Promise((resolve, reject) => {
    const jsmediatags = window.jsmediatags;

    jsmediatags.read(file, {
      onSuccess: function(tag) {
        // Extract data and convert ArrayBuffer to base64
        const picture = tag.tags.picture;
        let imageBase64 = '';
        if (picture) {
          const data = picture.data;
          const format = picture.format;
          let base64String = "";
          for (let i = 0; i < data.length; i++) {
            base64String += String.fromCharCode(data[i]);
          }
          imageBase64 = `data:${format};base64,${window.btoa(base64String)}`;
        }

        // Create the result object
        const result = {
          title: tag.tags.title || 'Unknown Title',
          artist: tag.tags.artist || 'Unknown Artist',
          image: imageBase64 || null
        };

        resolve(result);
      },
      onError: function(error) {
        reject('Error reading tags: ' + error);
      }
    });
  });
}
