// Tab switching functionality
document.addEventListener('DOMContentLoaded', function() {
    const tabButtons = document.querySelectorAll('.tab-button');
    const tabContents = document.querySelectorAll('.tab-content');

    tabButtons.forEach(button => {
        button.addEventListener('click', function() {
            const tabName = this.getAttribute('data-tab');
            
            // Remove active class from all buttons and contents
            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));
            
            // Add active class to clicked button and corresponding content
            this.classList.add('active');
            document.getElementById(tabName).classList.add('active');
        });
    });

    // Menu item switching
    const menuItems = document.querySelectorAll('.menu-item');
    menuItems.forEach(item => {
        item.addEventListener('click', function() {
            menuItems.forEach(mi => mi.classList.remove('active'));
            this.classList.add('active');
            
            const modeText = this.getAttribute('data-mode');
            console.log('Selected mode:', modeText);
        });
    });

    // Play button animation
    const playButton = document.querySelector('.play-button');
    if (playButton) {
        playButton.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.08)';
        });
        playButton.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
        });
    }

    // Feature cards hover animation
    const featureCards = document.querySelectorAll('.feature-card, .mode-card');
    featureCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
        });
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });

    // Add some interactivity to rating
    const ratingElement = document.querySelector('.game-rating');
    if (ratingElement) {
        ratingElement.style.cursor = 'pointer';
        ratingElement.addEventListener('click', function() {
            alert('Thanks for your interest in voting!');
        });
    }
});
