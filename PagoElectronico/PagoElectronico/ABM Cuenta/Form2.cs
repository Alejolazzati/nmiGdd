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
    public partial class Form2 : Form
    {
        altaCuentaPorAdm abmSuper;
        public Form2(altaCuentaPorAdm abmANterior)
        {
            InitializeComponent();
            abmSuper = abmANterior;
        }

        private void Form2_Load(object sender, EventArgs e)
        {

        }
    }
}
