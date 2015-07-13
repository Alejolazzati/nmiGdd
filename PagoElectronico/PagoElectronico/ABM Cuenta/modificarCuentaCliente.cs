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
    public partial class modificarCuentaCliente : Form
    {

        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();

        String nuevoTipo;   
        String cuenta;
        public modificarCuentaCliente(String unaCuenta)
        {
            cuenta = unaCuenta; //Lo necesitas para saber cual vas a actualizar
            InitializeComponent();

            //cargar categorias

            comando.CommandText = "Select descripcion from NMI.categoria";
            System.Data.SqlClient.SqlDataReader reader3 = comando.ExecuteReader();
            while (reader3.Read())
            {
                comboBox2.Items.Add(reader3.GetSqlString(0));

            }
            this.Show();
            reader3.Dispose();
        }

        private void modificarCuentaCliente_Load(object sender, EventArgs e)
        {

        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            nuevoTipo = comboBox2.SelectedItem.ToString();
        }
    }
}
