using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using NLog;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.XLHC.Sotham
{
    public partial class RutKhangCaoKhangNghi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal KHIEUNAI = 1, KIENNGHI = 2, KHANGNGHI = 3;
        private Logger logger = NLog.LogManager.GetCurrentClassLogger();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    LoadGrid();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(btnUpdate, oPer.CAPNHAT);
                    decimal ID = Convert.ToDecimal(current_id);
                    XLHC_DON oT = dt.XLHC_DON.Where(x => x.ID == ID).FirstOrDefault();
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(btnUpdate, false);
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        Cls_Comon.SetButton(btnUpdate, false);
                        return;
                    }
                    //KiemTraDonXL();
                }
            }
            catch (Exception ex) 
            { 
                lbthongbao.Text = ENUM_MESSAGE.SERVER_ERROR;
                logger.Error("[toaanid={} donid={}] loi xay ra: {}", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]), ex);
            }
        }
        public void LoadGrid()
        {
            XLHC_SOTHAM_BL oBL = new XLHC_SOTHAM_BL();
            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");
            DataTable oDT = oBL.XLHC_ST_KCKN_TINHTRANG_GETLIST_V2(ID);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = btnUpdate.Visible = true;
            }
            else
            {
                lbthongbao.Text = "Không có dữ liệu!";
                pndata.Visible = btnUpdate.Visible = false;
            }
        }

        private bool CheckValid(decimal DONID)
        {
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                return false;
            }

            return true;
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                String strMsg = "";
                int trangthai = 0, count_update = 0, is_ngayrut = 0;
                bool isNew = false;
                DateTime? dayKCKN = (DateTime?)null;
                decimal donId = Convert.ToDecimal(Request.QueryString["DON_ID"]);

                if (!CheckValid(donId))
                {
                    return;
                }

                foreach (DataGridItem item in dgList.Items)
                {
                    isNew = false;
                    decimal ID = item.Cells[0].Text.Equals("&nbsp;") ? 0 : Convert.ToDecimal(item.Cells[0].Text),
                        TYPE = Convert.ToDecimal(item.Cells[2].Text),
                        KNKNKCID = Convert.ToDecimal(item.Cells[1].Text);
                    TextBox txtNgayRut = (TextBox)item.FindControl("txtNgayRut");

                    DropDownList ddlTinhTrang = (DropDownList)item.FindControl("ddlTinhTrang");
                    trangthai = Convert.ToInt16(ddlTinhTrang.SelectedValue);
                    //nếu trạng thái không rút thì không cần xử lý gì cả
                    if (trangthai <=0 )
                    {
                        continue;
                    }
                    #region Validate Ngày Rút

                    if (txtNgayRut.Text != "" && Cls_Comon.IsValidDate(txtNgayRut.Text) == false)
                    {
                        lbthongbao.Text = "Ngày rút phải theo định dạng (dd/MM/yyyy)!";
                        txtNgayRut.Focus();
                        txtNgayRut.ForeColor = Color.Red;
                        return;
                    }
                    else if (txtNgayRut.Text != "")
                    {
                        int result =
                            DateTime.Compare(
                                DateTime.Parse(txtNgayRut.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault),
                                DateTime.Now);
                        if (result > 0)
                        {
                            lbthongbao.Text = "Ngày rút phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại!";
                            txtNgayRut.Focus();
                            txtNgayRut.ForeColor = Color.Red;
                            return;
                        }
                    }

                    DateTime? NgayRut = (String.IsNullOrEmpty(txtNgayRut.Text.Trim()))
                        ? (DateTime?)null
                        : DateTime.Parse(txtNgayRut.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    //Nếu rút thì ngày rút là bắt buộc
                    if (null == NgayRut)
                    {
                        lbthongbao.Text = "Bạn chưa nhập ngày rút. Hãy nhập lại!";
                        txtNgayRut.Focus();
                        txtNgayRut.ForeColor = Color.Red;
                        return;
                    }

                    if (TYPE == KHIEUNAI)
                    {
                        XLHC_SOTHAM_KHANGCAO kc = dt.XLHC_SOTHAM_KHANGCAO.Where(x => x.ID == KNKNKCID).FirstOrDefault();
                        if (kc != null)
                        {
                            dayKCKN = kc.NGAYKHANGCAO + "" == "" ? (DateTime?)null : (DateTime)kc.NGAYKHANGCAO;
                        }
                    }

                    if (NgayRut < dayKCKN)
                    {
                        string dayKCKNstr = ((DateTime)dayKCKN).ToString("dd/MM/yyyy");
                        lbthongbao.Text = "Ngày rút phải lớn hơn ngày khiếu nại/kiến nghị/kháng nghị " + dayKCKNstr +
                                          ". Hãy nhập lại!";
                        txtNgayRut.Focus();
                        txtNgayRut.ForeColor = Color.Red;
                        return;
                    }
                    else is_ngayrut++;

                    #endregion

                    

                    TextBox txtNoidung = (TextBox)item.FindControl("txtNoidung");
                    decimal DonID = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC] + "");

                    
                    int byteCount = Encoding.Unicode.GetByteCount(txtNoidung.Text.Trim());
                    if (byteCount > 200)
                    {
                        lbthongbao.Text = "Đã nhập quá kí tự cho phép! Vui lòng nhập lại!!";
                        return;
                    }

                    if (trangthai > 0 && is_ngayrut > 0)
                    {
                        XLHC_SOTHAM_RUTKCKN oND = dt.XLHC_SOTHAM_RUTKCKN
                            .Where(x => x.DONID == DonID && x.ISKCKN == TYPE && x.IDKCKN == KNKNKCID).FirstOrDefault();
                        if (oND == null)
                        {
                            isNew = true;
                            oND = new XLHC_SOTHAM_RUTKCKN();
                            oND.NGAYTAO = DateTime.Now;
                            oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        }
                        else
                        {
                            isNew = false;
                            oND.NGAYSUA = DateTime.Now;
                            oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        }

                        oND.DONID = DonID;
                        oND.ISKCKN = TYPE;
                        oND.IDKCKN = KNKNKCID;
                        oND.NGAYRUT = NgayRut;
                        oND.TRANGTHAI = Convert.ToDecimal(ddlTinhTrang.SelectedValue);
                        oND.NOIDUNGRUT = txtNoidung.Text.Trim();
                        
                        if (isNew)
                        {
                            oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            dt.XLHC_SOTHAM_RUTKCKN.Add(oND);
                        }

                        dt.SaveChanges();
                        lbthongbao.Text = "Lưu thành công!";
                        count_update++;
                    }
                    else
                    {
                        strMsg += (string.IsNullOrEmpty(strMsg) ? "" : ", ") + " [STT" + item.Cells[0].Text + "] " + item.Cells[4].Text + " của " +
                                  item.Cells[5].Text;
                    }
                }

                //Chẳng để làm gì
                //if (strMsg != "")
                //    lbthongbao.Text = strMsg +
                //                      " chưa thực hiện được việc rút KC/KN do chưa cập nhật đủ thông tin về ngày rút/ tình trạng.";
                if (count_update > 0)
                {
                    dgList.CurrentPageIndex = 0;
                    LoadGrid();
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
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
                    txtNgayRut.Text = string.IsNullOrEmpty(rv["NGAYRUT"] + "") ? "" : ((DateTime)rv["NGAYRUT"]).ToString("dd/MM/yyyy");
                    ddlTinhTrang.SelectedValue = rv["TRANGTHAI"].ToString();
                    txtNoidung.Text = rv["NOIDUNGRUT"].ToString();
                    string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
                    decimal DONID = Convert.ToDecimal(current_id);
                    // án chuyển đi rồi thì không hiển thị
                    //var donXL = dt.XLHC_CHUYEN_NHAN_AN.FirstOrDefault(x => x.VUANID == DONID);
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new XLHC_CHUYEN_NHAN_AN_BL().Check_NhanAn_V2(DONID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    if (Result != "")
                    {                       
                        lbtXoa.Visible = false;
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi!";
                    }

                    string toagiaiquyetID = e.Item.Cells[12].Text.Trim();
                    string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                    int tinhTrang = Convert.ToInt32(ddlTinhTrang.SelectedValue);
                    if (toagiaiquyetID != donviID)
                    {
                        lbtXoa.Visible = false;
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
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    xoa(ND_id);
                    break;
            }
        }

        public void xoa(decimal id)
        {
            decimal donId = Convert.ToDecimal(Request.QueryString["DON_ID"]);
            XLHC_SOTHAM_RUTKCKN rutKCKN = dt.XLHC_SOTHAM_RUTKCKN.FirstOrDefault(x => x.ID == id);

            if (!CheckValid((decimal) rutKCKN.DONID))
            {
                return;
            } else
            {
                
                rutKCKN.NGAYRUT = null;
                rutKCKN.TRANGTHAI = 0;
                rutKCKN.NOIDUNGRUT = "";

                dt.SaveChanges();
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                lbthongbao.Text = "Xóa dữ liệu thành công!";

            }
        }

        private void KiemTraDonXL()
        {
            // án chuyển đi rồi thì không hiển thị
            string current_id = Session[ENUM_LOAIAN.BPXLHC] + "";
            decimal donID = Convert.ToDecimal(current_id);
            var anXL = dt.XLHC_CHUYEN_NHAN_AN.Where(x => x.VUANID == donID).FirstOrDefault();
            if (anXL != null)
            {
                Cls_Comon.SetButton(btnUpdate, false);
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi!";
            }
        }

    }
}