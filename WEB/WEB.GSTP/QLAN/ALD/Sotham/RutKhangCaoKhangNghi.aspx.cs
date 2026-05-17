using BL.GSTP;
using BL.GSTP.ALD;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.ALD.Sotham
{
    public partial class RutKhangCaoKhangNghi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal KHANGCAO = 1, KHANGNGHI = 2;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ALD/Hoso/Danhsach.aspx");
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
                    decimal ID = Convert.ToDecimal(current_id);
                    ALD_DON oT = dt.ALD_DON.Where(x => x.ID == ID).FirstOrDefault();
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(btnUpdate, false);
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new ALD_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        Cls_Comon.SetButton(btnUpdate, false);
                        return;
                    }

                    //DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
                    //DataTable oCBDT = oDMCBBL.CHECK_CHUCDANH_THUKY_USER(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY, (decimal)Session[ENUM_SESSION.SESSION_CANBOID]);
                    //int counttk = oCBDT.Rows.Count;
                    //if (counttk > 0)
                    //{
                    //    //là thư k
                    //    decimal IdNhomNguoiSuDung = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID]);
                    //    decimal CurrentUserId = (decimal)Session[ENUM_SESSION.SESSION_CANBOID];
                    //    //int count = dt.QT_NHOMNGUOIDUNG.Count(s => s.ID == IdNhomNguoiSuDung && (s.TEN.Contains("HCTP") || s.TEN.Contains("TAND")));
                    //    int countItem = dt.ALD_DON_THAMPHAN.Count(s => s.THUKYID == CurrentUserId && s.DONID == ID && s.MAVAITRO == "VTTP_GIAIQUYETSOTHAM");
                    //    if (countItem > 0)
                    //    {
                    //        //được gán 
                    //    }
                    //    else
                    //    {
                    //        //không được gán
                    //        StrMsg = "Người dùng không được sửa đổi thông tin của vụ việc do không được phân công giải quyết.";
                    //        lbthongbao.Text = StrMsg;
                    //        Cls_Comon.SetButton(btnUpdate, false);
                    //        return;
                    //    }
                    //}
                    //Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    //if(anKetThuc)
                    //{
                    //    lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                    //    Cls_Comon.SetButton(btnUpdate, false);
                    //    return;
                    //}
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadGrid()
        {
            lbthongbao.Text = "";
            ALD_SOTHAM_BL oBL = new ALD_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
            DataTable oDT = oBL.ALD_ST_KCKN_TINHTRANG_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                lbthongbao.Text = "Không có dữ liệu!";
                pndata.Visible = false;
            }
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                String strMsg = "";
                int trangthai = 0, count_update = 0, is_ngayrut = 0;
                bool isNew = false;
                DateTime? dayKCKN = (DateTime?)null;
                foreach (DataGridItem item in dgList.Items)
                {
                    decimal ID = item.Cells[0].Text.Equals("&nbsp;") ? 0 : Convert.ToDecimal(item.Cells[0].Text);
                    Decimal isKhangCao = Convert.ToDecimal(item.Cells[2].Text);
                    decimal KCKNID = Convert.ToDecimal(item.Cells[1].Text);
                    #region Validate Ngày Rút
                    TextBox txtNgayRut = (TextBox)item.FindControl("txtNgayRut");
                    if (txtNgayRut.Text != "" && Cls_Comon.IsValidDate(txtNgayRut.Text) == false)
                    {
                        lbthongbao.Text = "Ngày rút phải theo định dạng (dd/MM/yyyy)!";
                        txtNgayRut.Focus();
                        txtNgayRut.ForeColor = Color.Red;
                        return;
                    }
                    else if (txtNgayRut.Text != "")
                    {
                        int result = DateTime.Compare(DateTime.Parse(txtNgayRut.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault), DateTime.Now);
                        if (result > 0)
                        {
                            lbthongbao.Text = "Ngày rút phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại!";
                            txtNgayRut.Focus();
                            txtNgayRut.ForeColor = Color.Red;
                            return;
                        }
                    }
                    DateTime? NgayRut = (String.IsNullOrEmpty(txtNgayRut.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgayRut.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                    if (isKhangCao == KHANGCAO)// Kháng cáo
                    {
                        ALD_SOTHAM_KHANGCAO kc = dt.ALD_SOTHAM_KHANGCAO.Where(x => x.ID == KCKNID).FirstOrDefault();
                        if (kc != null)
                        {
                            dayKCKN = kc.NGAYKHANGCAO + "" == "" ? (DateTime?)null : (DateTime)kc.NGAYKHANGCAO;
                        }
                    }
                    else
                    {
                        ALD_SOTHAM_KHANGNGHI kn = dt.ALD_SOTHAM_KHANGNGHI.Where(x => x.ID == KCKNID).FirstOrDefault();
                        if (kn != null)
                        {
                            dayKCKN = kn.NGAYKN + "" == "" ? (DateTime?)null : (DateTime)kn.NGAYKN;
                        }
                    }
                    if (NgayRut < dayKCKN)
                    {
                        string dayKCKNstr = ((DateTime)dayKCKN).ToString("dd/MM/yyyy");
                        lbthongbao.Text = "Ngày rút phải lớn hơn ngày kháng cáo/kháng nghị " + dayKCKNstr + ". Hãy nhập lại!";
                        txtNgayRut.Focus();
                        txtNgayRut.ForeColor = Color.Red;
                        return;
                    }
                    else is_ngayrut++;
                    #endregion
                    DropDownList ddlTinhTrang = (DropDownList)item.FindControl("ddlTinhTrang");

                    TextBox txtNoidung = (TextBox)item.FindControl("txtNoidung");
                    decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG] + "");
                    trangthai = Convert.ToInt16(ddlTinhTrang.SelectedValue);
                    if (trangthai > 0 && is_ngayrut > 0)
                    {
                        ALD_SOTHAM_RUTKCKN oND = dt.ALD_SOTHAM_RUTKCKN.Where(x => x.DONID == DonID
                                                                               && x.ISKCKN == isKhangCao
                                                                               && x.IDKCKN == KCKNID).FirstOrDefault();
                        ALD_SOTHAM_KHANGCAO kc = dt.ALD_SOTHAM_KHANGCAO.Where(x => x.DONID == DonID
                                                                                && x.ID == KCKNID).FirstOrDefault();
                        ALD_SOTHAM_KHANGNGHI kn = dt.ALD_SOTHAM_KHANGNGHI.Where(x => x.DONID == DonID
                                                                                && x.ID == KCKNID).FirstOrDefault();
                        if (oND == null)
                        {
                            isNew = true;
                            oND = new ALD_SOTHAM_RUTKCKN();
                            oND.NGAYTAO = DateTime.Now;
                            oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        }
                        else
                        {
                            oND.NGAYSUA = DateTime.Now;
                            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        }
                        oND.DONID = DonID;
                        oND.ISKCKN = isKhangCao;
                        oND.IDKCKN = KCKNID;
                        oND.NGAYRUT = NgayRut;
                        oND.TRANGTHAI = trangthai;
                        oND.NOIDUNGRUT = txtNoidung.Text;
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        //toancau_tamnc hiển thị rút kháng cáo khi rút kháng cáo toàn bộ
                        if (oND.TRANGTHAI == 2 && isKhangCao == 1 && kc != null)
                        { kc.TINHTRANG_GIAIQUYET = 2; }
                        else if (oND.TRANGTHAI != 2 && isKhangCao == 1 && kc != null && kc.TINHTRANG_GIAIQUYET != 1)
                        { kc.TINHTRANG_GIAIQUYET = 0; }
                        else
                        //toancau_tamnc hiển  thị rút kháng nghị khi rút kháng cáo toàn bộ
                        if (oND.TRANGTHAI == 2 && isKhangCao == 2 && kn != null)
                        { kn.TINHTRANG_GIAIQUYET = 3; }
                        else if (oND.TRANGTHAI != 2 && isKhangCao == 2 && kn != null && kn.TINHTRANG_GIAIQUYET != 1)
                        { kn.TINHTRANG_GIAIQUYET = 0; }
                        if (isNew)
                        {
                            dt.ALD_SOTHAM_RUTKCKN.Add(oND);
                        }
                        dt.SaveChanges();
                        lbthongbao.Text = "Lưu thành công!";
                        count_update++;
                    }
                    else
                    {
                        if (trangthai > 0)
                            strMsg += (string.IsNullOrEmpty(strMsg) ? "" : ",") + item.Cells[4].Text + " của " + item.Cells[5].Text;
                    }
                }
                if (strMsg != "")
                    lbthongbao.Text = strMsg + " chưa thực hiện được việc rút KC/KN do chưa cập nhật đủ thông tin về ngày rút/ tình trạng.";
                if (count_update > 0)
                {
                    dgList.CurrentPageIndex = 0;
                    LoadGrid();
                }
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    TextBox txtNgayRut = (TextBox)e.Item.FindControl("txtNgayRut");
                    DropDownList ddlTinhTrang = (DropDownList)e.Item.FindControl("ddlTinhTrang");
                    TextBox txtNoidung = (TextBox)e.Item.FindControl("txtNoidung");
                    DataRowView rv = (DataRowView)e.Item.DataItem;
                    txtNgayRut.Text = string.IsNullOrEmpty(rv["NGAYRUT"] + "") ? "" : ((DateTime)rv["NGAYRUT"]).ToString("dd/MM/yyyy");
                    txtNoidung.Text = rv["NOIDUNGRUT"].ToString();
                    ImageButton img = (ImageButton)e.Item.FindControl("cmdXoa");
                    string current_id = Session[ENUM_LOAIAN.AN_LAODONG] + "";

                    decimal ID = Convert.ToDecimal(current_id);

                    ALD_DON oT = dt.ALD_DON.Where(x => x.ID == ID).FirstOrDefault();
                    if (txtNgayRut.Text == "" || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                        img.Visible = false;
                    else
                    {
                        img.Visible = true;
                        ddlTinhTrang.Items.Clear();
                        ddlTinhTrang.Items.Add(new ListItem("Rút một phần", "1"));
                        ddlTinhTrang.Items.Add(new ListItem("Rút toàn bộ", "2"));
                    }
                    ddlTinhTrang.SelectedValue = rv["TRANGTHAI"].ToString();

                    //toancau_tamnc ẩn tình trạng khi án đã được phúc thẩm giải quyết
                    var TINHTRANG_GIAIQUYET = string.IsNullOrEmpty(rv["TINHTRANG_GIAIQUYET"] + "") ? 0 : ((decimal)rv["TINHTRANG_GIAIQUYET"]);
                    if (TINHTRANG_GIAIQUYET == 1)
                    {
                        ddlTinhTrang.Visible = false;
                        img.Visible = false;
                    }

                    string toagiaiquyetID = rv.Row["TOA_GIAIQUYET_ID"].ToString();
                    string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                    if (!toagiaiquyetID.Equals(donviID))
                    {
                        //khong cho nut xoa
                        img.Visible = false;
                        txtNgayRut.ReadOnly = true;
                        ddlTinhTrang.Enabled = false;
                        txtNoidung.ReadOnly = true;
                        if (string.IsNullOrWhiteSpace(DataBinder.Eval(e.Item.DataItem, "ID")?.ToString()?.Trim()))
                        {
                            txtNgayRut.ReadOnly = false;
                            ddlTinhTrang.Enabled = true;
                            txtNoidung.ReadOnly = false;
                        }
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            String vCurr;
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "Xoa":
                    vCurr = e.CommandArgument.ToString();
                    curr_id = Convert.ToDecimal(vCurr);
                    XoaKhangCao_KN(curr_id);
                    LoadGrid();
                    break;
            }
        }
        protected void ddlTinhTrang_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddlTinhTrang = (DropDownList)sender;
            decimal trangthai = Convert.ToDecimal(ddlTinhTrang.SelectedValue);
            DataGridItem item = (DataGridItem)((Control)sender).Parent.Parent;
            TextBox txtNgayRut = (TextBox)item.FindControl("txtNgayRut");

            if (trangthai > 0)
            {
                if (txtNgayRut.Text == "")
                    txtNgayRut.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            }
            else
                txtNgayRut.Text = "";
        }
        void XoaKhangCao_KN(decimal curr_id)
        {
            if (curr_id > 0)
            {
                ALD_SOTHAM_RUTKCKN oT = dt.ALD_SOTHAM_RUTKCKN.Where(x => x.ID == curr_id).FirstOrDefault();
                ALD_SOTHAM_KHANGCAO kc = dt.ALD_SOTHAM_KHANGCAO.Where(x => x.ID == oT.IDKCKN).FirstOrDefault();
                ALD_SOTHAM_KHANGNGHI kn = dt.ALD_SOTHAM_KHANGNGHI.Where(x => x.ID == oT.IDKCKN).FirstOrDefault();
                if (oT != null)
                {
                    if (kc != null)
                    {
                        kc.TINHTRANG_GIAIQUYET = 0;
                    }
                    if (kn != null)
                    {
                        kn.TINHTRANG_GIAIQUYET = 0;
                    }
                    dt.ALD_SOTHAM_RUTKCKN.Remove(oT);
                    dt.SaveChanges();
                }
            }
            lbthongbao.Text = "Xóa thành công!";
        }
    }
}