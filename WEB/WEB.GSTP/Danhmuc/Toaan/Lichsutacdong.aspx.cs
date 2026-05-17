using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc.Toaan
{
    public partial class Lichsutacdong : System.Web.UI.Page
    {
        private string PUBLIC_DEPT = "..";
        GSTPContext dt = new GSTPContext();
        private const int ROOT = 0, DEL = 0, ADD = 1, UPDATE = 2;
      
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadLichSuTacDongList();
                }
            }
            catch (Exception ex) { lblThongBaoSapNhap.Text = ex.Message; }
        }
     
       

        #region "Quản lý sáp nhập tòa án"

     





        /// <summary>
        /// Load danh sách sáp nhập từ database - Xử lý null values an toàn
        /// </summary>
        private void LoadLichSuTacDongList()
        {
            try
            {
                // Lấy ID tòa án hiện tại được chọn
                decimal toaAnID = 0;
                if (!string.IsNullOrEmpty(Request["toaid"]) && decimal.TryParse(Request["toaid"], out toaAnID) && toaAnID > 0)
                {
                    // Lấy dữ liệu từ BL
                    BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();
                    DataTable dtSapNhap = bl.GETS_BY_TOTOAANTID(toaAnID);

                    if (dtSapNhap != null && dtSapNhap.Rows.Count > 0)
                    {
                        // Xử lý null values trước khi bind
                        ProcessNullValuesInDataTable(dtSapNhap);

                        dgSapNhap.DataSource = dtSapNhap;
                        dgSapNhap.DataBind();

                        // Hiển thị số lượng bản ghi
                        lblThongBaoSapNhap.Text = $"Tìm thấy {dtSapNhap.Rows.Count} bản ghi sáp nhập.";
                        lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Green;
                    }
                    else
                    {
                        // Không có dữ liệu
                        dgSapNhap.DataSource = null;
                        dgSapNhap.DataBind();

                        lblThongBaoSapNhap.Text = "Chưa có thông tin sáp nhập cho tòa án này.";
                        lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Blue;
                    }
                }
                else
                {
                    // Chưa chọn tòa án
                    dgSapNhap.DataSource = null;
                    dgSapNhap.DataBind();

                    lblThongBaoSapNhap.Text = "Vui lòng chọn tòa án để xem danh sách sáp nhập.";
                    lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Orange;
                }
            }
            catch (Exception ex)
            {
                lblThongBaoSapNhap.Text = "Lỗi load danh sách sáp nhập: " + ex.Message;
                lblThongBaoSapNhap.ForeColor = System.Drawing.Color.Red;

                // Log lỗi để debug
                System.Diagnostics.Debug.WriteLine($"LoadSapNhapList Error: {ex.Message}");

                // Clear grid khi có lỗi
                dgSapNhap.DataSource = null;
                dgSapNhap.DataBind();
            }
        }

        /// <summary>
        /// Xử lý null values trong DataTable để tránh lỗi khi bind vào DataGrid
        /// </summary>
        private void ProcessNullValuesInDataTable(DataTable dt)
        {
            if (dt == null || dt.Rows.Count == 0) return;

            try
            {
                foreach (DataRow row in dt.Rows)
                {
                    // Xử lý column NGAYHETHIEULUC nếu null
                    if (row["NGAYHETHIEULUC"] == DBNull.Value)
                    {
                        // Có thể để null hoặc set giá trị mặc định
                        // row["NGAYHETHIEULUC"] = DateTime.MinValue; // Nếu muốn set giá trị mặc định
                    }

                    // Xử lý column NGAYHIEULUC nếu null
                    if (row["NGAYHIEULUC"] == DBNull.Value)
                    {
                        // row["NGAYHIEULUC"] = DateTime.MinValue; // Nếu muốn set giá trị mặc định
                    }

                    // Xử lý các column string nếu null
                    if (row["LOAI"] == DBNull.Value)
                    {
                        row["LOAI"] = "";
                    }

                    // Xử lý HIEULUC nếu null
                    if (row["HIEULUC"] == DBNull.Value)
                    {
                        row["HIEULUC"] = 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"ProcessNullValuesInDataTable Error: {ex.Message}");
            }
        }

      

       

   

        /// <summary>
        /// DataBound event của DataGrid sáp nhập - Xử lý null values an toàn
        /// </summary>
        protected void dgSapNhap_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    // Xử lý dữ liệu của từng row để đảm bảo không có lỗi null
                    DataRowView rowView = (DataRowView)e.Item.DataItem;

                    // Có thể xử lý format dữ liệu ở đây nếu cần
                    // Ví dụ: format ngày, hiệu lực, v.v.

                    // Xử lý quyền hạn nếu có
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                    // Có thể ẩn/hiện button sửa/xóa dựa trên quyền
                    // LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                    // LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    // if (lbtSua != null) lbtSua.Visible = oPer.CAPNHAT;
                    // if (lbtXoa != null) lbtXoa.Visible = oPer.XOA;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"dgSapNhap_ItemDataBound Error: {ex.Message}");
                // Không throw exception để tránh crash trang
            }
        }


        #endregion
    }
}