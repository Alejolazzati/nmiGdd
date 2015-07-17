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
    public partial class SeleccionarCuenta : Form
    {
        int num;
        public SeleccionarCuenta(int i)
        {
            num = i;
            InitializeComponent();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select * from NMI.cuentasPorCliente(" + Program.cliente + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlValue(0));
             


            }
            this.Show();
            reader.Dispose();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (comboBox1.SelectedIndex == -1) { MessageBox.Show("Seleccione una cuenta de origen"); return; }
            Program.cuenta = comboBox1.SelectedItem.ToString();
            if (num==1)
            new PagoElectronico.Transferencias.nuevaTransferencia(comboBox1.SelectedItem.ToString()).Show();
        if (num == 2)
        {
         
            new PagoElectronico.Facturacion.pagarSuscripciones().Show();
        }
        if (num == 3)
        {
            new PagoElectronico.Retiros.altaRetiro().Show();
        }
                
                this.Close();
        }

        private void SeleccionarCuenta_Load(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
