using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System.Web.UI.WebControls;

namespace WEB.GSTP.Danhmuc.BieuMauBC
{

    public partial class SuaBC : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                 LoadComponent();
                if (!String.IsNullOrEmpty(Request["vID"] + ""))
                {
                    //LoadComponent();
                    LoadInfo();
                }
            }
        }
        void LoadComponent()
        {
            LoadDropLoai();
            LoadDMQUYETDINH();


        }
        void LoadDMQUYETDINH()
        {
            DM_QD_QUYETDINH_BL oBL = new DM_QD_QUYETDINH_BL();
            DataTable lst = oBL.DM_QD_QUYETDINH_SEARCH(0, null, 1, 500);
            if (lst != null && lst.Rows.Count > 0)
            {
                ddlQuyetdinh.DataSource = lst;
                ddlQuyetdinh.DataTextField = "TEN";
                ddlQuyetdinh.DataValueField = "ID";
                ddlQuyetdinh.DataBind();
            }
            ddlQuyetdinh.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            ddlQuyetdinh.SelectedIndex = 0;

        }
        void LoadDropLoai()
        {
            dropLoai.Items.Clear();
            dropLoai.Items.Add(new ListItem("---------- chọn -------------", "0"));
            dropLoai.Items.Add(new ListItem("Dân sự", (ENUM_LOAIVUVIEC.AN_DANSU) + ""));
            dropLoai.Items.Add(new ListItem("Hình sự", (ENUM_LOAIVUVIEC.AN_HINHSU) + ""));
            dropLoai.Items.Add(new ListItem("Hành chính", (ENUM_LOAIVUVIEC.AN_HANHCHINH) + ""));
            dropLoai.Items.Add(new ListItem("Hôn nhân - Gia đình ", (ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH) + ""));
            dropLoai.Items.Add(new ListItem("Kinh doanh, thương mại", (ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI) + ""));
            dropLoai.Items.Add(new ListItem("Lao động", (ENUM_LOAIVUVIEC.AN_LAODONG) + ""));
            dropLoai.Items.Add(new ListItem("Phá sản", (ENUM_LOAIVUVIEC.AN_PHASAN) + ""));
            dropLoai.Items.Add(new ListItem("Biện pháp XLHC", (ENUM_LOAIVUVIEC.BPXLHC) + ""));
            dropLoai.Items.Add(new ListItem("Thi hành án", (ENUM_LOAIVUVIEC.AN_THA) + ""));
        }      
        void LoadInfo()
        {
            int bieumauID = (Request.QueryString["vID"] != null) ? Convert.ToInt32(Request.QueryString["vID"] + "") : 0;
            if (bieumauID > 0)
            {
                DM_BIEUMAU obj = dt.DM_BIEUMAU.Where(x => x.ID == bieumauID).FirstOrDefault<DM_BIEUMAU>();
                if (obj != null)
                {
                    hddCurrID.Value = bieumauID + "";
                    txtTen.Text = obj.TENBM;
                    txtMa.Text = obj.MABM;
                    txtDuongdan.Text = obj.DUONGDAN;
                    txtThuTu.Text = obj.THUTU + "";
                    ddlQuyetdinh.SelectedValue = obj.QUYETDINHID == null ? "0" : ((Decimal)obj.QUYETDINHID).ToString("00"); ;
                    //dropLoai.SelectedValue = obj.LOAIAN == null ? "0" : ((Decimal)obj.LOAIAN).ToString("00");

                    chkActive.Checked = Convert.ToBoolean(obj.ACTIVE);
                    chkNguyendon.Checked= (obj.IS_TD_NGUYENDON+"") == "1" ? true : false;
                    chkDuongsu.Checked = (obj.IS_TD_DUONGSU + "") == "1" ? true : false;
                    chkVKS.Checked = (obj.IS_TD_VKS + "") == "1" ? true : false;

                    chkIsHoso.Checked = (obj.ISHOSO + "") == "1" ? true : false;
                    chkIsSotham.Checked = (obj.ISSOTHAM + "") == "1" ? true : false;
                    chkIsPhuctham.Checked = (obj.ISPHUCTHAM + "") == "1" ? true : false;
                    chkIsGDT.Checked = (obj.ISGDTTT + "") == "1" ? true : false;
                    chkPrint.Checked = (obj.ISPRINT + "") == "1" ? true : false;

                    chkHinhSu.Checked = (obj.ISAHS + "") == "1" ? true : false;
                    chkDanSu.Checked = (obj.ISADS + "") == "1" ? true : false;
                    chkHonNhanGD.Checked = (obj.ISAHN + "") == "1" ? true : false;
                    chkKDTM.Checked = (obj.ISAKT + "") == "1" ? true : false;
                    chkHanhChinh.Checked = (obj.ISAHC + "") == "1" ? true : false;
                    chkLaoDong.Checked = (obj.ISALD + "") == "1" ? true : false;
                    chkPhasan.Checked = (obj.ISAPS + "") == "1" ? true : false;
                    chkXLHC.Checked = (obj.ISXLHC + "") == "1" ? true : false;
                    chkTHA.Checked = (obj.ISTHA + "") == "1" ? true : false;

                    chkISLUONHIENTHI.Checked = (obj.ISLUONHIENTHI + "") == "1" ? true : false;
                }
            }
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            Resetcontrol();
        }
        protected void Resetcontrol()
        {
            txtTen.Text = "";
            txtDuongdan.Text = "";
            hddCurrID.Value = "0";
          
            chkActive.Checked = false;
        }


        private void loadthutu()
        {
            txtTen.Text = "";
          //  txtDuongdan.Text = "";
            txtMa.Text = "";          
          
            List<DM_BIEUMAU> lstbm = new List<DM_BIEUMAU>();
            lstbm = dt.DM_BIEUMAU.ToList();
            txtThuTu.Text = (Convert.ToString(lstbm.Count + 1));
            txtMa.Focus();
            hddCurrID.Value = "0";
        }

        protected void btnQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("DanhmucBM.aspx");
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            decimal DMID = (String.IsNullOrEmpty(hddCurrID.Value)) ? 0 : Convert.ToDecimal(hddCurrID.Value);

            bool is_new = false;
            DM_BIEUMAU BM = new DM_BIEUMAU();
            if (DMID > 0)
            {
                BM = dt.DM_BIEUMAU.Where(x => x.ID == DMID).FirstOrDefault<DM_BIEUMAU>();
                if (BM == null)
                {
                    is_new = true;
                    BM = new DM_BIEUMAU();
                }
            }
            else
                is_new = true;
            BM.TENBM = txtTen.Text.Trim();
            BM.MABM = txtMa.Text.Trim();
            //BM.LOAIAN = Convert.ToDecimal(dropLoai.SelectedValue);
            BM.DUONGDAN = txtDuongdan.Text.Trim();
            BM.QUYETDINHID = Convert.ToDecimal(ddlQuyetdinh.SelectedValue);


            BM.ACTIVE = chkActive.Checked ? 1 : 0;
            BM.THUTU = (string.IsNullOrEmpty(txtThuTu.Text.Trim())) ? 1 : Convert.ToDecimal(txtThuTu.Text.Trim());
            BM.IS_TD_NGUYENDON = chkNguyendon.Checked ? 1 : 0;
            BM.IS_TD_DUONGSU = chkDuongsu.Checked ? 1 : 0;
            BM.IS_TD_VKS = chkVKS.Checked ? 1 : 0;

            BM.ISHOSO = chkIsHoso.Checked ? 1 : 0;
            BM.ISSOTHAM = chkIsSotham.Checked ? 1 : 0;
            BM.ISPHUCTHAM = chkIsPhuctham.Checked ? 1 : 0;
            BM.ISGDTTT= chkIsGDT.Checked ? 1 : 0;
            BM.ISPRINT = chkPrint.Checked ? 1 : 0;

            BM.ISAHS = chkHinhSu.Checked ? 1 : 0;
            BM.ISADS = chkDanSu.Checked ? 1 : 0;
            BM.ISAHN = chkHonNhanGD.Checked ? 1 : 0;
            BM.ISAKT = chkKDTM.Checked ? 1 : 0;
            BM.ISAHC = chkHanhChinh.Checked ? 1 : 0;
            BM.ISALD = chkLaoDong.Checked ? 1 : 0;
            BM.ISAPS = chkPhasan.Checked ? 1 : 0;
            BM.ISXLHC = chkXLHC.Checked ? 1 : 0;
            BM.ISTHA = chkTHA.Checked ? 1 : 0;
            BM.ISLUONHIENTHI = chkISLUONHIENTHI.Checked ? 1 : 0;
            if (is_new)
                dt.DM_BIEUMAU.Add(BM);
            dt.SaveChanges();

            loadthutu();
            hddCurrID.Value = "0";
            lbthongbao.Text = "Lưu thành công!";
        }
    }
}