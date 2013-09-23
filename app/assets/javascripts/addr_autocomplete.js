function initialize() {
    var input = document.getElementById('location_address');
    var options = {componentRestrictions: {country: 'us'}};
                 
    new google.maps.places.Autocomplete(input, options);
}
             
google.maps.event.addDomListener(window, 'load', initialize);