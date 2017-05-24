export default class MainView {
  mount() {
    //  This will be executed when the document loads...
    let logout_link = document.getElementsByClassName("logout-link")
    if (logout_link.length > 0) {
      logout_link[0].onclick = () => {
        let xhttp = new XMLHttpRequest();
        xhttp.open("DELETE","/logout",false);
        xhttp.send();
        window.location.href = '/'
      };
    };
  }
}
