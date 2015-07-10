using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Cliente
{
    public partial class modificarCliente : Form
    {
        String cliente;
        public modificarCliente(String clie)
        {
            cliente = clie;
            InitializeComponent();
        }

        private void modificarCliente_Load(object sender, EventArgs e)
        {

        }
    }
}
