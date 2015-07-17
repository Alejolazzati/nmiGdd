using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Login
{
    public partial class SeleccionarCliente : Form
    {
        int num;
        public SeleccionarCliente(int i)
        {
            num = i;
            InitializeComponent();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }


        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox3.Text.Length == 0) { MessageBox.Show("Ingrese los datos del cliente"); return; }
            Program.cliente = Convert.ToInt32(textBox3.Text);
            if (num == 1)
            {

                new PagoElectronico.Facturacion.Facturacion().Show();
                this.Close();
            }
            if (num == 2)
            {
                new ABM_Cuenta.buscarCuentaCliente().Show();
                this.Close();
            }
        }

        private void SeleccionarCliente_Load(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            new Funcionalidades().Show();
        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
