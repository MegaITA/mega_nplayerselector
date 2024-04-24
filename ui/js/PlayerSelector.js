class PlayerSelector extends HTMLElement {

    constructor(_id, _x, _y) {
        super();
        this._id = _id;
        this._x = _x;
        this._y = _y;
        this.create();
    }
    
    create() {
        this.classList.add('selector-container');
        this.setAttribute('playerId', this._id);
        const id = document.createElement('p');
        id.classList.add('selector-id');
        id.innerHTML = `ID: ${this._id}`;
        const img = document.createElement('img');
        img.classList.add('selector-img');
        img.setAttribute('src', './img/selector.png')
        this.appendChild(id);
        this.appendChild(img);
        this.style.left = this._x + 'px';
        this.style.top = this._y + 'px';
    }

    move(x, y) {
        this.style.left = x + 'px';
        this.style.top = y + 'px';
    }

}