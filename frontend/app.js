const API_VENTAS = "/api/v1/ventas";
const API_DESPACHOS = "/api/v1/despachos";

function mostrarEstado(mensaje, tipo = "ok") {
  const status = document.getElementById("status");
  status.textContent = mensaje;
  status.className = "status " + tipo;
}

async function cargarVentas() {
  try {
    const response = await fetch(API_VENTAS);
    const ventas = await response.json();

    const tbody = document.getElementById("tablaVentas");
    tbody.innerHTML = "";

    ventas.forEach((venta) => {
      const fila = document.createElement("tr");

      fila.innerHTML = `
        <td>${venta.idVenta ?? ""}</td>
        <td>${venta.direccionCompra ?? ""}</td>
        <td>${venta.valorCompra ?? ""}</td>
        <td>${venta.fechaCompra ?? ""}</td>
        <td>${venta.despachoGenerado ? "Sí" : "No"}</td>
      `;

      tbody.appendChild(fila);
    });

    mostrarEstado("Ventas cargadas correctamente", "ok");
  } catch (error) {
    console.error(error);
    mostrarEstado("Error al cargar ventas", "error");
  }
}

async function crearVenta() {
  try {
    const direccionCompra = document.getElementById("direccionCompra").value;
    const valorCompra = Number(document.getElementById("valorCompra").value);
    const fechaCompra = document.getElementById("fechaCompra").value;

    const nuevaVenta = {
      direccionCompra,
      valorCompra,
      fechaCompra,
      despachoGenerado: false
    };

    const response = await fetch(API_VENTAS, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(nuevaVenta)
    });

    if (!response.ok) {
      throw new Error("No se pudo crear la venta");
    }

    mostrarEstado("Venta creada correctamente", "ok");
    cargarVentas();
  } catch (error) {
    console.error(error);
    mostrarEstado("Error al crear venta", "error");
  }
}

async function cargarDespachos() {
  try {
    const response = await fetch(API_DESPACHOS);
    const despachos = await response.json();

    const tbody = document.getElementById("tablaDespachos");
    tbody.innerHTML = "";

    despachos.forEach((despacho) => {
      const fila = document.createElement("tr");

      fila.innerHTML = `
        <td>${despacho.idDespacho ?? ""}</td>
        <td>${despacho.idCompra ?? ""}</td>
        <td>${despacho.direccionCompra ?? ""}</td>
        <td>${despacho.fechaDespacho ?? ""}</td>
        <td>${despacho.patenteCamion ?? ""}</td>
        <td>${despacho.intento ?? ""}</td>
        <td>${despacho.despachado ? "Sí" : "No"}</td>
      `;

      tbody.appendChild(fila);
    });

    mostrarEstado("Despachos cargados correctamente", "ok");
  } catch (error) {
    console.error(error);
    mostrarEstado("Error al cargar despachos", "error");
  }
}

cargarVentas();
cargarDespachos();