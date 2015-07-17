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
    public partial class calendar : Form
    {
        int textBox;
        altaTarjeta abmLlamo;
        public calendar(int textBoxLlamo,altaTarjeta abmL)
        {
            InitializeComponent();
            monthCalendar1.TodayDate = Convert.ToDateTime(Program.fecha);
            monthCalendar1.MaxSelectionCount = 1;
            abmLlamo = abmL;
            textBox = textBoxLlamo;
        }

    

        private void button1_Click(object sender, EventArgs e)
        {
            abmLlamo.recibirFecha(textBox, monthCalendar1.SelectionRange.Start);
            this.Close();
        }
    }
}
