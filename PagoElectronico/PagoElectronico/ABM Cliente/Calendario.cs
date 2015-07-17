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
    public partial class Calendario : Form
    {
        PagoElectronico.ABM_Cliente.altaCliente abmSuper;
        public Calendario(PagoElectronico.ABM_Cliente.altaCliente unABM)
        {
            InitializeComponent();
            monthCalendar1.TodayDate = Convert.ToDateTime(Program.fecha);
            monthCalendar1.MaxSelectionCount = 1;
            abmSuper = unABM;
        }

       
        private void button1_Click(object sender, EventArgs e)
        {
            abmSuper.recibirFecha(monthCalendar1.SelectionRange.Start);
            this.Close();
        }

        
    }
}
