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
        public SeleccionarCuenta()
        {
            InitializeComponent();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select * from cuentasPorCliente(" + Program.cliente + ")";
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
            new PagoElectronico.Transferencias.nuevaTransferencia(comboBox1.SelectedItem.ToString()).Show();
            this.Close();
        }
    }
}
