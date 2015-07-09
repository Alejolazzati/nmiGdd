using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Cuenta
{
    public partial class modificarCuentaCliente : Form
    {
        String cuenta;
        public modificarCuentaCliente(String unaCuenta)
        {
            cuenta = unaCuenta; //Lo necesitas para saber cual vas a actualizar
            InitializeComponent();
        }

        private void modificarCuentaCliente_Load(object sender, EventArgs e)
        {

        }
    }
}
