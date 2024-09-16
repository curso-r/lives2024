// Select all elements with the 'lang-choice' class
const langChoices = document.querySelectorAll('.lang-option');

// Add a click event listener to each element
langChoices.forEach(choice => {
    choice.addEventListener('click', function() {
        // Remove the 'active' class from all elements
        langChoices.forEach(el => el.classList.remove('lang-active'));
        
        // Add the 'active' class to the clicked element
        this.classList.add('lang-active');
    });
});
