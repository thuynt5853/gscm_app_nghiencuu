using BL.GSTP.AHS;
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

namespace WEB.GSTP.QLAN.AHS.PhucTham
{
    public partial class RutKCKN_Sotham : System.Web.UI.Page
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
                    string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);

                    //check vu an ket thuc de thong bao khong cho sua
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                        Cls_Comon.SetButton(btnUpdate, false);
                        return;
                    }

                    //string StrMsg = "Không được sửa đổi thông tin.";
                    //string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    //if (Result != "")
                    //{
                    //    lbthongbao.Text = Result;
                    //    Cls_Comon.SetButton(btnUpdate, false);
                    //    return;
                    //}
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadGrid()
        {
            AHS_PHUCTHAM_BL oBL = new AHS_PHUCTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_PT_KCKN_TinhTrang_GETLIST(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }

        void XoaKhangCao_KN(decimal curr_id, decimal type_kckn)
        {
            if (curr_id > 0)
            {
                if (type_kckn == 1)
                {
                    AHS_SOTHAM_RUTKHANGCAO oT = dt.AHS_SOTHAM_RUTKHANGCAO.Where(x => x.ID == curr_id).FirstOrDefault();
                    if (oT != null)
                    {
                        //Anhpn 
                        decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                        AHS_SOTHAM_RUTKHANGNGHI AHS_SOTHAM_RUTKHANGNGHI = dt.AHS_SOTHAM_RUTKHANGNGHI.Where(x => x.ID == DONID).FirstOrDefault<AHS_SOTHAM_RUTKHANGNGHI>();
                        if (AHS_SOTHAM_RUTKHANGNGHI != null)
                        {
                            lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin rút kháng nghị.";
                            return;
                        }
                        AHS_PHUCTHAM_QUYETDINH_VUAN AHS_PHUCTHAM_QUYETDINH_VUAN = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == DONID).FirstOrDefault<AHS_PHUCTHAM_QUYETDINH_VUAN>();
                        if (AHS_PHUCTHAM_QUYETDINH_VUAN != null)
                        {
                            lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin quyết định vụ án.";
                            return;
                        }
                        AHS_PHUCTHAM_BANAN AHS_PHUCTHAM_BANAN = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == DONID).FirstOrDefault<AHS_PHUCTHAM_BANAN>();
                        if (AHS_PHUCTHAM_BANAN != null)
                        {
                            lbthongbao.Text = "Xóa không thành công! Do đang tồn tại bản án.";
                            return;
                        }
                        dt.AHS_SOTHAM_RUTKHANGCAO.Remove(oT);
                        dt.SaveChanges();
                    }
                }
                else
                {
                    AHS_SOTHAM_RUTKHANGNGHI oT = dt.AHS_SOTHAM_RUTKHANGNGHI.Where(x => x.ID == curr_id).FirstOrDefault();
                    if (oT != null)
                    {
                        //Anhpn 
                        decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                        AHS_SOTHAM_RUTKHANGCAO AHS_SOTHAM_RUTKHANGCAO = dt.AHS_SOTHAM_RUTKHANGCAO.Where(x => x.ID == DONID).FirstOrDefault<AHS_SOTHAM_RUTKHANGCAO>();
                        if (AHS_SOTHAM_RUTKHANGCAO != null)
                        {
                            lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin rút kháng cáo.";
                            return;
                        }
                        AHS_PHUCTHAM_QUYETDINH_VUAN AHS_PHUCTHAM_QUYETDINH_VUAN = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.ID == DONID).FirstOrDefault<AHS_PHUCTHAM_QUYETDINH_VUAN>();
                        if (AHS_PHUCTHAM_QUYETDINH_VUAN != null)
                        {
                            lbthongbao.Text = "Xóa không thành công! Do đang tồn tại thông tin quyết định vụ án.";
                            return;
                        }
                        AHS_PHUCTHAM_BANAN AHS_PHUCTHAM_BANAN = dt.AHS_PHUCTHAM_BANAN.Where(x => x.VUANID == DONID).FirstOrDefault<AHS_PHUCTHAM_BANAN>();
                        if (AHS_PHUCTHAM_BANAN != null)
                        {
                            lbthongbao.Text = "Xóa không thành công! Do đang tồn tại bản án.";
                            return;
                        }
                        dt.AHS_SOTHAM_RUTKHANGNGHI.Remove(oT);
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
       
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                    TextBox txtNgayRut = (TextBox)e.Item.FindControl("txtNgayRut");
                    DropDownList ddlTinhTrang = (DropDownList)e.Item.FindControl("ddlTinhTrang");
                    TextBox txtNoidung = (TextBox)e.Item.FindControl("txtNoidung");
                    DataRowView rv = (DataRowView)e.Item.DataItem;
                    //txtNgayRut.Text = string.IsNullOrEmpty(rv["NGAYRUT"] + "") ? "" : DateTime.Parse(rv["NGAYRUT"].ToString(), cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                    txtNgayRut.Text = rv["NGAYRUT"].ToString();
                    ddlTinhTrang.SelectedValue = rv["TINHTRANG"].ToString();
                    txtNoidung.Text = rv["NOIDUNG"].ToString();
                    ImageButton img = (ImageButton)e.Item.FindControl("cmdXoa");
                    if (txtNgayRut.Text=="")
                        img.Visible = false;
                    else
                        img.Visible = true;

                    // check quyền để hiển thị nút xoá
                    string toaGiaiQuyetID = e.Item.Cells[12].Text.Trim();
                    string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                    if (toaGiaiQuyetID != donviID)
                    {
                        img.Visible = false;
                    }

                    //check vu an ket thuc de thong bao khong cho sua
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        img.Visible = false;
                    }

                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
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
                            oND.CAPRUTKN = 3;
                            if (ID == 0)
                            {
                                oND.NGAYTAO = DateTime.Now;
                                oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                if (oND.TOA_GIAIQUYET_ID == null)
                                {
                                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                }

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
                            oND.CAPRUTKN = 3;
                            if (ID == 0)
                            {
                                oND.NGAYTAO = DateTime.Now;
                                oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                if (oND.TOA_GIAIQUYET_ID == null)
                                {
                                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                }

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