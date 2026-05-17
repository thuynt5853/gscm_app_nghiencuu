using BL.GSTP.AHS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.SoTham
{
    public partial class RutKhangCaoKhangNghi : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();
        private CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal KHANGCAO = 1, KHANGNGHI = 2;
        public Boolean isRutKhangCao = false;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
                    decimal VuAnID = Convert.ToDecimal(current_id);

                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc && isRutKhangCao)
                    {
                        lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                        Cls_Comon.SetButton(btnUpdate, false);
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
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
                    //    int countItem = dt.AHS_THAMPHANGIAIQUYET.Count(s => s.THUKYID == CurrentUserId && s.VUANID == VuAnID && s.MAVAITRO == "VTTP_GIAIQUYETSOTHAM");
                    //    if (countItem > 0)
                    //    {
                    //        //được gán
                    //    }
                    //    else
                    //    {
                    //        //không được gán
                    //        StrMsg = "Người dùng không được sửa đổi thông tin của vụ án do không được phân công giải quyết.";
                    //        lbthongbao.Text = StrMsg;
                    //        Cls_Comon.SetButton(btnUpdate, false);
                    //        return;
                    //    }
                    //}
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        public void LoadGrid()
        {
            AHS_SOTHAM_BL oBL = new AHS_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_ST_KCKN_TinhTrang_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                isRutKhangCao = true;
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                isRutKhangCao = false;
                pndata.Visible = false;
            }
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
                    txtNgayRut.Text = rv["NGAYRUT"].ToString();
                    txtNoidung.Text = rv["NOIDUNG"].ToString();
                    ImageButton img = (ImageButton)e.Item.FindControl("cmdXoa");

                    if (txtNgayRut.Text == "")
                        img.Visible = false;
                    else
                    {
                        img.Visible = true;
                        ddlTinhTrang.Items.Clear();
                        ddlTinhTrang.Items.Add(new ListItem("Rút một phần", "1"));
                        ddlTinhTrang.Items.Add(new ListItem("Rút toàn bộ", "2"));
                    }
                    ddlTinhTrang.SelectedValue = rv["TINHTRANG"].ToString();
                    var TINHTRANG_GIAIQUYET = string.IsNullOrEmpty(rv["TINHTRANG_GIAIQUYET"] + "") ? 0 : ((decimal)rv["TINHTRANG_GIAIQUYET"]);
                    if (TINHTRANG_GIAIQUYET == 1)
                    {
                        ddlTinhTrang.Visible = false;
                        img.Visible = false;
                    }

                    // check quyền để hiển thị nút xoá
                    string toaGiaiQuyetID = e.Item.Cells[12].Text.ToString();
                    string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                    if (toaGiaiQuyetID != donviID)
                    {
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

        private void XoaKhangCao_KN(decimal curr_id, decimal type_kckn)
        {
            if (curr_id > 0)
            {
                if (type_kckn == 1)
                {
                    AHS_SOTHAM_RUTKHANGCAO oT = dt.AHS_SOTHAM_RUTKHANGCAO.Where(x => x.ID == curr_id).FirstOrDefault();
                    if (oT != null)
                    {
                        dt.AHS_SOTHAM_RUTKHANGCAO.Remove(oT);
                        AHS_SOTHAM_KHANGCAO kc = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == oT.KHANGCAOID).FirstOrDefault();
                        if (kc != null)
                        {
                            kc.TINHTRANG_GIAIQUYET = 0;
                        }
                        dt.SaveChanges();
                    }
                }
                else
                {
                    AHS_SOTHAM_RUTKHANGNGHI oT = dt.AHS_SOTHAM_RUTKHANGNGHI.Where(x => x.ID == curr_id).FirstOrDefault();
                    if (oT != null)
                    {
                        dt.AHS_SOTHAM_RUTKHANGNGHI.Remove(oT);
                        AHS_SOTHAM_KHANGNGHI kn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == oT.KHANGNGHIID).FirstOrDefault();
                        if (kn != null)
                        {
                            kn.TINHTRANG_GIAIQUYET = 0;
                        }
                        dt.SaveChanges();
                    }
                }
            }
            lbthongbao.Text = "Xóa thành công!";
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            String vCurr;
            decimal vIsKCKN;
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "Xoa":
                    vCurr = e.CommandArgument.ToString();
                    int position = vCurr.IndexOf("$");

                    curr_id = Convert.ToDecimal(vCurr.Substring(0, position));
                    vIsKCKN = Convert.ToDecimal(vCurr.Substring(position + 1));
                    XoaKhangCao_KN(curr_id, vIsKCKN);
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

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                String strMsg = "";
                int trangthai = 0, count_update = 0, is_ngayrut = 0;

                foreach (DataGridItem item in dgList.Items)
                {
                    decimal ID = item.Cells[0].Text.Equals("&nbsp;") ? 0 : Convert.ToDecimal(item.Cells[0].Text),
                        isKhangCao = Convert.ToDecimal(item.Cells[2].Text), KCKNID = Convert.ToDecimal(item.Cells[1].Text);

                    TextBox txtNgayRut = (TextBox)item.FindControl("txtNgayRut");

                    String str_ngayrut = String.IsNullOrEmpty(txtNgayRut.Text.Trim()) ? "" : txtNgayRut.Text.Trim();

                    if (str_ngayrut != "")
                    {
                        if (Cls_Comon.IsValidDate(str_ngayrut) == false)
                        {
                            lbthongbao.Text = "Ngày rút phải theo định dạng (dd/MM/yyyy)!";
                            txtNgayRut.Focus();
                            txtNgayRut.ForeColor = Color.Red;
                            return;
                        }
                        //------------------------------
                        int result = DateTime.Compare(DateTime.Parse(str_ngayrut, cul, DateTimeStyles.NoCurrentDateDefault), DateTime.Now);
                        if (result > 0)
                        {
                            lbthongbao.Text = "Ngày rút phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại!";
                            txtNgayRut.Focus();
                            txtNgayRut.ForeColor = Color.Red;
                            return;
                        }
                        else is_ngayrut++;
                    }
                    else
                        is_ngayrut = 0;

                    DropDownList ddlTinhTrang = (DropDownList)item.FindControl("ddlTinhTrang");
                    trangthai = Convert.ToInt16(ddlTinhTrang.SelectedValue);

                    TextBox txtNoidung = (TextBox)item.FindControl("txtNoidung");
                    if (trangthai > 0 && is_ngayrut > 0)
                    {
                        if (isKhangCao == KHANGCAO)// Kháng cáo
                        {
                            AHS_SOTHAM_RUTKHANGCAO oND;

                            if (ID == 0)
                                oND = new AHS_SOTHAM_RUTKHANGCAO();
                            else
                            {
                                oND = dt.AHS_SOTHAM_RUTKHANGCAO.Where(x => x.ID == ID).FirstOrDefault();
                            }
                            oND.KHANGCAOID = KCKNID;
                            oND.NGAYRUT = (String.IsNullOrEmpty(txtNgayRut.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgayRut.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            oND.TINHTRANG = Convert.ToDecimal(ddlTinhTrang.SelectedValue);
                            oND.NOIDUNG = txtNoidung.Text;

                            AHS_SOTHAM_KHANGCAO kc = dt.AHS_SOTHAM_KHANGCAO.Where(x => x.ID == KCKNID).FirstOrDefault();
                            //toancau_linhnd_hiển thị rút kháng cáo khi rút kháng cáo toàn bộ
                            if (oND.TINHTRANG == 2 && kc != null)
                            { kc.TINHTRANG_GIAIQUYET = 2; }
                            else if (oND.TINHTRANG != 2 && kc != null && kc.TINHTRANG_GIAIQUYET != 1)
                            { kc.TINHTRANG_GIAIQUYET = 0; }

                            if (ID == 0)
                            {
                                oND.NGAYTAO = DateTime.Now;
                                oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                                oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                dt.AHS_SOTHAM_RUTKHANGCAO.Add(oND);
                            }
                            else
                            {
                                oND.NGAYSUA = DateTime.Now;
                                oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            }
                            dt.SaveChanges();
                        }
                        else// Kháng nghị
                        {
                            AHS_SOTHAM_RUTKHANGNGHI oND;

                            if (ID == 0)
                                oND = new AHS_SOTHAM_RUTKHANGNGHI();
                            else
                            {
                                oND = dt.AHS_SOTHAM_RUTKHANGNGHI.Where(x => x.ID == ID).FirstOrDefault();
                            }

                            oND.KHANGNGHIID = KCKNID;
                            oND.NGAYRUT = (String.IsNullOrEmpty(txtNgayRut.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgayRut.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                            oND.TINHTRANG = Convert.ToDecimal(ddlTinhTrang.SelectedValue);
                            oND.NOIDUNG = txtNoidung.Text;

                            AHS_SOTHAM_KHANGNGHI kn = dt.AHS_SOTHAM_KHANGNGHI.Where(x => x.ID == KCKNID).FirstOrDefault();
                            if (oND.TINHTRANG == 2 && kn != null)
                            { kn.TINHTRANG_GIAIQUYET = 3; }
                            else if (oND.TINHTRANG != 2 && kn != null && kn.TINHTRANG_GIAIQUYET != 1)
                            { kn.TINHTRANG_GIAIQUYET = 0; }

                            if (ID == 0)
                            {
                                oND.NGAYTAO = DateTime.Now;
                                oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                                oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                dt.AHS_SOTHAM_RUTKHANGNGHI.Add(oND);
                            }
                            else
                            {
                                oND.NGAYSUA = DateTime.Now;
                                oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            }
                            dt.SaveChanges();
                        }
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
    }
}