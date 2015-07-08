using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico
{
    public partial class ERROR : Form
    {
        public ERROR()
        {
            InitializeComponent();
        }

        public void Mostrar(String error){
            this.Show();
            label1.Text = error;
        }

        private void label1_Click(object sender, EventArgs e)
        {
            this.Hide();
            this.Close();
        }


        
    }
}
