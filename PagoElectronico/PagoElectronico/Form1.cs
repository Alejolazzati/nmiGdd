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
    public partial class Form1 : Form
    {
        altaCuentaPorCliente abmLlamo;
        public Form1(altaCuentaPorCliente superABM)
        {
            InitializeComponent();
            abmLlamo = superABM;
            monthCalendar1.MaxSelectionCount = 1;
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            abmLlamo.recibirFecha(monthCalendar1.SelectionRange.Start);
            this.Close();
        }
    }
}
