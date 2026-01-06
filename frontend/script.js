function toggleMenu() {
  const menu = document.querySelector(".menu-links");
  const icon = document.querySelector(".hamburger-icon");
  menu.classList.toggle("open");
  icon.classList.toggle("open");
}

// visiter counter

async function updateVisitorCount() {
  try {
    console.log("start the counter");
    const response = await fetch("http://localhost:7071/api/GetResumeCounter");
    if (!response.ok) {
      throw new Error("Network response was not ok");
    }
    const data = await response.json();
    const display = document.getElementById("visitor-counter-number");
    if (display) {
      display.innerText = data.count;
    }
  } catch (error) {
    console.error("There has been a problem with your fetch operation:", error);
  }
}

updateVisitorCount();
