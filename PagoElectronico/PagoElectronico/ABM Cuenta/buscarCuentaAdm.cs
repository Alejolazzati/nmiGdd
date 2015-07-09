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
    public partial class buscarCuentaAdm : Form
    {
        public buscarCuentaAdm()
        {
            InitializeComponent();
        }

        private void button9_Click(object sender, EventArgs e)
        {
            new PagoElectronico.ABM_Cuenta.altaCuentaPorAdm().Show();
        }
    }
}
