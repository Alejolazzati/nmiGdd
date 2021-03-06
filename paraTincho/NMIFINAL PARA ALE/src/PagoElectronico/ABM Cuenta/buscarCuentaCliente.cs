﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Cuenta
{
    public partial class buscarCuentaCliente : Form
    {
        public buscarCuentaCliente()
        {
            InitializeComponent();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select * from NMI.cuentasPorCliente(" + Program.cliente + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox2.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();



        }

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            String cuenta = listBox2.SelectedItem.ToString();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select NMI.saldoCuenta(" + cuenta + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            reader.Read();
            textBox1.Text = reader.GetSqlValue(0).ToString();
            reader.Dispose();
        }

        private void buscarCuentaCliente_Load(object sender, EventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)
        {

            PagoElectronico.Login.Funcionalidades funci = new PagoElectronico.Login.Funcionalidades();
            funci.Show();
            this.Close();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            String cuenta;
            try
            {
                cuenta = listBox2.SelectedItem.ToString();
            }
            catch (NullReferenceException er) { MessageBox.Show("Seleccione una cuenta de la lista"); return; }
       
            new PagoElectronico.ABM_Cuenta.modificarCuenta(cuenta).Show();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            new PagoElectronico.ABM_Cuenta.altaCuenta().Show();
            this.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            String cuenta;
            try
            {
               cuenta = listBox2.SelectedItem.ToString();   
            }
            catch (NullReferenceException er) { MessageBox.Show("Seleccione una cuenta de la lista"); return; }
        
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "exec NMI.bajaCuenta " +cuenta;
            try { comando.ExecuteNonQuery();
                MessageBox.Show("Operacion exitosa");}
            catch (System.Data.SqlClient.SqlException er) { MessageBox.Show(er.Message); }
            new Login.Funcionalidades().Show();
            this.Close();
            
        }
    }
}
