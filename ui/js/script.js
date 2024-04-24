let selectors = new Map();

customElements.define('player-selector', PlayerSelector);

window.addEventListener('message', function(event) {
    if(event.data.active) {
        for(const pos of event.data.positions) {
            if(selectors.has(pos.id)) {
                let selector = selectors.get(pos.id);
                selector.move(pos.coords[0]*window.innerWidth, pos.coords[1]*window.innerHeight);
            } else {
                let selector = new PlayerSelector(pos.id, pos.coords[0]*window.innerWidth, pos.coords[1]*window.innerHeight)
                selectors.set(pos.id, selector)
                document.body.appendChild(selector)
                selector.addEventListener('click', function(e) {
                    sendSelectedPlayer(e.currentTarget.getAttribute('playerid'))
                })
            }
        }
    } else {
        clearSelectors()
    }
})

document.body.addEventListener('keyup', function(e) {
    if (e.key == "Escape") {
        clearSelectors()
        fetch(`https://${GetParentResourceName()}/closeSelector`, { method: 'POST' })
    }
});

function clearSelectors() {
    for(const [key, selector] of selectors) {
        selector.remove()
    }
    selectors = new Map();
}

function sendSelectedPlayer(id) {
    fetch(`https://${GetParentResourceName()}/onPlayerSelected`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            id: id
        })
    })
}