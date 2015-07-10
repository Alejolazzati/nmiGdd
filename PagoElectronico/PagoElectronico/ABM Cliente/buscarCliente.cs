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
    public partial class buscarCliente : Form
    {
        public buscarCliente()
        {
            InitializeComponent();
        }

        private void button8_Click(object sender, EventArgs e)
        {
            new PagoElectronico.ABM_Cliente.altaCliente().Show();
            this.Close();
        }
    }
}
