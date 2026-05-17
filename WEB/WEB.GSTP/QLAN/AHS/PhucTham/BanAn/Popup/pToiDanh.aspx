<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pToiDanh.aspx.cs" Inherits="WEB.GSTP.QLAN.AHS.PhucTham.BanAn.Popup.pToiDanh" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Điều luật áp dụng cho bị cáo</title>
    <link href="../../../../../UI/css/style.css" rel="stylesheet" />
    <script src="../../../../../UI/js/Common.js"></script>
    <link href="../../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../../UI/css/chosen.css" rel="stylesheet" />

    <link href="../../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../../UI/js/init.js"></script>
    <script src="../../../../../UI/js/chosen.jquery.js"></script>
    <style>
        body {
            width: 98%;
            margin-left: 1%;
            min-width: 0px;
        }

        .box {
            height: 750px;
            overflow: auto;
            padding-left: 20px;
            box-sizing: border-box;
        }

        .boxchung {
            float: left;
        }

        .boder {
            float: left;
            width: 96%;
            padding: 10px 1.5%;
        }

        .row_change, .row_change td {
            background: yellow;
        }

        .row_no_change {
            background: white;
        }

        .align_right {
            text-align: right;
        }


        .title_hp {
            font-weight: bold;
            text-transform: uppercase;
            float: left;
            width: 100%;
            margin-bottom: 5px;
            border-top: dashed 1px #dcdcdc;
            padding-top: 10px;
            margin-top: 10px;
        }

        .margin_top {
            margin-top: 5px;
            float: left;
        }

        .span_date {
            margin-right: 5px;
        }

        #tblHP tr, td {
            vertical-align: top;
            padding-bottom: 2px;
        }

            #tblHP tr, td a {
                color: #333;
            }

        /*.buttoninput {
            float: left;
            margin-right: 5px;
        }*/

        .highlightRow {
            background-color: yellow;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" enableviewstate="true">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>


        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:HiddenField ID="hddStatusAnTreo" Value="0" runat="server" />
                <asp:HiddenField ID="hddGiaiDoanVuAn" Value="" runat="server" />
                <asp:HiddenField ID="hddID" runat="server" Value="0" />
                <asp:HiddenField ID="hddCurrToiDanhID" runat="server" Value="0" />
                <asp:HiddenField ID="hddBanAnID" runat="server" Value="0" />
                <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                <!-------------------------->

                <div class="box">
                    <div class="box_nd">
                        <div>
                            <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                <asp:Literal ID="lstMsgT" runat="server"></asp:Literal>
                            </div>
                            <div class="boxchung">
                                <h4 class="tleboxchung">Điều luật áp dụng cho bị cáo</h4>
                                <div class="boder">
                                    <table class="table1">
                                        <tr>
                                            <td style="width: 65px;"><b>Tên bị cáo</b></td>
                                            <td style="width: 250px;">
                                                <asp:DropDownList ID="dropBiCao" CssClass="chosen-select"
                                                    runat="server" Width="250px"
                                                    AutoPostBack="true" OnSelectedIndexChanged="dropBiCao_SelectedIndexChanged">
                                                </asp:DropDownList>
                                            </td>

                                            <td style="width: 65px;"><b>Bộ luật</b><span class="batbuoc">(*)</span></td>
                                            <td>
                                                <asp:DropDownList ID="dropBoLuat" runat="server"
                                                    CssClass="chosen-select" Width="250px"
                                                    AutoPostBack="true" OnSelectedIndexChanged="dropBoLuat_SelectedIndexChanged">
                                                </asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td><b>Điểm</b></td>
                                            <td>
                                                <asp:TextBox ID="txtDiem" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                                                <b style="width: 50px;">Khoản</b><span class="batbuoc">(*)</span>

                                                <asp:TextBox ID="txtKhoan" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                                            </td>
                                            <td>
                                                <b style="width: 50px;">Điều<span class="batbuoc">(*)</span></b> </td>
                                            <td>
                                                <asp:TextBox ID="txtDieu" runat="server" CssClass="user" Width="60px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="3">
                                                <div style="margin: 5px; text-align: center; width: 95%">
                                                    <asp:Button ID="cmdThemDieuLuat" runat="server" CssClass="buttoninput"
                                                        Text="Thêm" OnClick="cmdThemDieuLuat_Click"
                                                        OnClientClick="return ValidateThemDL();" />
                                                    <%-- <input type="button" id="cmdTongHopHinhPhat" onclick="popupTongHopHinhPhat();" value="Tổng hợp hình phạt" class="buttoninput" />--%>
                                                    <asp:Button ID="cmdChonDieuLuat" runat="server" CssClass="buttoninput"
                                                        Text="Chọn điều luật áp dụng" OnClientClick="popupChonToiDanh();" />
                                                    <asp:Button ID="btnChonToiDanhChinh" runat="server" CssClass="buttoninput"
                                                        Text="Chọn tội danh chính" OnClick="btnChonToiDanhChinh_Click" />
                                                    <input type="button" class="buttoninput"
                                                        onclick="window.close();" value="Đóng" />
                                                </div>

                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="zone_ghichu">
                                    <b>Ghi chú</b><br />
                                    <b>Để cập nhật hình phạt cho từng tội danh</b><br />
                                    1. Bấm chọn 1 mục trong danh sách điều luật được áp dụng cho bị cáo<br />
                                    2. Chọn "hình phạt" tương ứng trong danh sách các hình phạt hiển thị<br />
                                    3. Ấn chọn "Lưu hình phạt" để cập nhật thông tin
                                </div>
                                <div style="margin: 5px; text-align: center; width: 95%; color: red;">
                                    <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                                </div>
                                <asp:Panel runat="server" ID="pndata" Visible="false">
                                    <div class="phantrang">
                                        <div class="sobanghi">
                                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                        </div>
                                        <div class="sotrang">
                                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                                OnClick="lbTBack_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                            <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                                OnClick="lbTNext_Click"></asp:LinkButton>
                                        </div>
                                    </div>
                                    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" OnItemDataBound="rpt_ItemDataBound">
                                        <HeaderTemplate>
                                            <table class="table2" width="100%" border="1">
                                                <tr class="header">
                                                    <td width="42">
                                                        <div align="center"><strong>TT</strong></div>
                                                    </td>
                                                    <td width="10%">
                                                        <div align="center"><strong>Tên bộ luật</strong></div>
                                                    </td>

                                                    <td width="50px">
                                                        <div align="center"><strong>Điều</strong></div>
                                                    </td>
                                                    <td width="50px">
                                                        <div align="center"><strong>Khoản</strong></div>
                                                    </td>

                                                    <td width="50px">
                                                        <div align="center"><strong>Điểm</strong></div>
                                                    </td>
                                                    <td>
                                                        <div align="center"><strong>Tội danh</strong></div>
                                                    </td>
                                                    <td width="50px">
                                                        <div><strong>Là tội danh chính</strong></div>
                                                    </td>
                                                    <td width="100">
                                                        <div align="center"><strong>Thao tác</strong></div>
                                                    </td>
                                                </tr>
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Panel ID="pnRow" runat="server">
                                                <tr class="trclass">
                                                    <td>
                                                        <asp:HiddenField ID="hddToiDanh" runat="server" Value='<%#Eval("ToiDanhID") %>' />
                                                        <asp:HiddenField ID="hddBoLuat" runat="server" Value='<%#Eval("DieuLuatID") %>' />
                                                        <asp:LinkButton ID="lk" runat="server" CommandArgument='<%#Eval("ToiDanhID") %>'
                                                            CommandName="view" Text='<%# Eval("STT") %>'></asp:LinkButton>
                                                        <asp:Image ID="Image" ImageUrl="../../../../../UI/img/check.png" runat="server" Visible="false" />
                                                    </td>
                                                    <td>
                                                        <asp:LinkButton ID="LinkButton1" runat="server"
                                                            CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="view" Text='<%#Eval("TenBoLuat") %>'></asp:LinkButton></td>

                                                    <td>
                                                        <asp:LinkButton ID="LinkButton4" runat="server" CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="view" Text='<%# Eval("Dieu") %>'></asp:LinkButton></td>

                                                    <td>
                                                        <asp:LinkButton ID="LinkButton3" runat="server" CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="view" Text='<%# Eval("Khoan") %>'></asp:LinkButton></td>
                                                    <td>
                                                        <asp:LinkButton ID="LinkButton2" runat="server" CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="view" Text='<%# Eval("Diem") %>'></asp:LinkButton></td>
                                                    <td>
                                                        <asp:LinkButton ID="LinkButton5" runat="server" CommandArgument='<%#Eval("ToiDanhID") %>' CommandName="view" Text='<%# Eval("TenToiDanh") %>'></asp:LinkButton></td>
                                                    <td>
                                                        <div align="center">
                                                            <asp:CheckBox ID="checkkboxTDC" runat="server" Checked='<%# CheckToiDanh(Eval("ISMAIN")) %>' Enabled="false" />

                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div align="center">
                                                            <asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                                                CommandName="Xoa" CommandArgument='<%#Eval("ToiDanhID") %>' ToolTip="Xóa"
                                                                OnClientClick="return confirm('Bạn thực sự muốn xóa mục này? ');"></asp:LinkButton>
                                                        </div>
                                                    </td>
                                                </tr>

                                            </asp:Panel>
                                        </ItemTemplate>
                                        <FooterTemplate></table></FooterTemplate>
                                    </asp:Repeater>

                                    <div class="phantrang">
                                        <div class="sobanghi">
                                            <asp:HiddenField ID="hdicha" runat="server" />
                                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                        </div>
                                        <div class="sotrang">
                                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                                OnClick="lbTBack_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                            <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                            <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                                OnClick="lbTNext_Click"></asp:LinkButton>
                                        </div>
                                    </div>
                                </asp:Panel>
                                <asp:Panel ID="pnHinhPhat" runat="server" Visible="false">
                                    <b class="title_hp">
                                        <asp:Literal ID="lttToiDanh" runat="server"></asp:Literal></b>

                                    <div style="float: left; width: 100%; text-align: center;">
                                        <asp:Button ID="cmdSaveHinhPhat" runat="server" CssClass="buttoninput"
                                            Text="Lưu hình phạt" OnClick="cmdSaveHinhPhat_Click" />
                                    </div>
                                    <div style="margin: 5px; text-align: center; width: 60%; color: red; float: right;">
                                        <asp:Literal ID="lblThongBaoHP" runat="server"></asp:Literal>
                                    </div>
                                    <!------------------------------------------>
                                    <asp:HiddenField ID="hddHinhPhatChange" runat="server" Value="0" />
                                    <asp:HiddenField ID="hddGroupChange" runat="server" Value="0" />
                                    <div class="boxchung">
                                        <h4 class="tleboxchung bg_title_group bg_green">
                                            <asp:Literal ID="lttNhomHPChinh" runat="server"></asp:Literal></h4>
                                        <div class="boder" style="padding: 20px 10px;">
                                            <asp:Repeater ID="rptHPChinh" runat="server"
                                                OnItemDataBound="rptHP_ItemDataBound">
                                                <HeaderTemplate>
                                                    <table style="width: 100%;" id="tblHP">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td style="width: 35%;"><%# Eval("TenHinhPhat") %></td>
                                                        <td style="width: 50px;">
                                                            <div style="float: left; width: 100%; text-align: center;">
                                                                <asp:CheckBox ID="chk" ToolTip='<%#Eval("ID") %>' runat="server" AutoPostBack="true" />
                                                            </div>
                                                            <asp:HiddenField ID="hddGroup" runat="server" Value='<%#Eval("NHOMHINHPHAT") %>' />
                                                            <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("LoaiHinhPHat") %>' />
                                                            <asp:HiddenField ID="hddHinhPhatID" runat="server" Value='<%#Eval("ID") %>' />
                                                        </td>
                                                        <td>
                                                            <asp:Panel ID="pnZoneHinhPhat" runat="server" Enabled="false">
                                                                <asp:RadioButtonList ID="rdDefaultTrue" runat="server"
                                                                    RepeatDirection="Horizontal" Visible="false">
                                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                                </asp:RadioButtonList>
                                                                <!-------------------------->
                                                                <asp:RadioButtonList ID="rdTrueFalse" runat="server"
                                                                    RepeatDirection="Horizontal" Visible="false">
                                                                    <asp:ListItem Value="0">Không</asp:ListItem>
                                                                    <asp:ListItem Value="1">Có</asp:ListItem>
                                                                </asp:RadioButtonList>
                                                                <!-------------------------->
                                                                <asp:TextBox ID="txtSohoc" CssClass="user" Width="100px"
                                                                    runat="server" onkeyup="javascript:this.value=Comma(this.value);" onkeypress="return isNumber(event)" Visible="false"></asp:TextBox>
                                                                <!-------------------------->
                                                                <asp:Panel ID="pnThoiGian" runat="server" Visible="false">
                                                                    <asp:TextBox ID="txtNam" CssClass="user" Width="40px" runat="server"
                                                                        Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                    <span class='span_date'>năm&nbsp;&nbsp;</span>
                                                                    <asp:TextBox ID="txtThang" CssClass="user" Width="40px" runat="server"
                                                                        Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                    <span class='span_date'>tháng&nbsp;&nbsp;</span>
                                                                    <asp:TextBox ID="txtNgay" CssClass="user" Width="40px" runat="server"
                                                                        Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                    <span class='span_date'>ngày</span>
                                                                </asp:Panel>
                                                                <!-------------------------->
                                                                <asp:Panel ID="pnKhac" runat="server" Visible="false">
                                                                    <asp:TextBox ID="txtKhac1" CssClass="user" Width="100px" runat="server"
                                                                        Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                    hoặc
                                                                <asp:TextBox ID="txtKhac2" runat="server" CssClass="user"
                                                                    Width="100px" Text=""></asp:TextBox>
                                                                </asp:Panel>

                                                                <!-------------------------->
                                                                <asp:CheckBox ID="chkAnTreo" runat="server" AutoPostBack="true"
                                                                    Text="Hưởng án treo" CssClass="margin_top" /><br />

                                                                <asp:Panel ID="pnThoiGianThuThach" runat="server" Visible="false">
                                                                    <div style="float: left; width: 95%">
                                                                        <span>Thử thách: </span>
                                                                        <asp:TextBox ID="txtTGTT_Nam" CssClass="user" Width="40px" runat="server"
                                                                            Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                        <span class='span_date'>năm&nbsp;&nbsp;</span>
                                                                        <asp:TextBox ID="txtTGTT_Thang" CssClass="user" Width="40px" runat="server"
                                                                            Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                        <span class='span_date'>tháng&nbsp;&nbsp;</span>
                                                                        <asp:TextBox ID="txtTGTT_Ngay" CssClass="user" Width="40px" runat="server"
                                                                            Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                        <span class='span_date'>ngày</span>
                                                                    </div>
                                                                </asp:Panel>
                                                            </asp:Panel>
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></table></FooterTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                    <!---------------------------------------->
                                    <div class="boxchung">
                                        <h4 class="tleboxchung bg_title_group bg_green">
                                            <asp:Literal ID="lttNhomHPBoSung" runat="server"></asp:Literal></h4>
                                        <div class="boder" style="padding: 20px 10px;">
                                            <asp:Repeater ID="rptHPBoSung" runat="server"
                                                OnItemDataBound="rptHPBoSung_ItemDataBound">
                                                <HeaderTemplate>
                                                    <table style="width: 100%;" id="tblHPBoSung">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>
                                                        <td style="width: 35%;"><%# Eval("TenHinhPhat") %></td>
                                                        <td style="width: 50px;">
                                                            <div style="float: left; width: 100%; text-align: center;">
                                                                <asp:CheckBox ID="chk" ToolTip='<%#Eval("ID") %>' runat="server" Visible="false" />
                                                            </div>
                                                            <asp:HiddenField ID="hddGroup" runat="server" Value='<%#Eval("NHOMHINHPHAT") %>' />
                                                            <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("LoaiHinhPHat") %>' />
                                                            <asp:HiddenField ID="hddHinhPhatID" runat="server" Value='<%#Eval("ID") %>' />
                                                        </td>
                                                        <td>

                                                            <asp:CheckBox ID="chkDefaultTrue" runat="server" Visible="false" />
                                                            <asp:CheckBox ID="chkTrueFalse" runat="server" Visible="false" />
                                                            <asp:TextBox ID="txtSohoc" CssClass="user" Width="100px"
                                                                runat="server" onkeyup="javascript:this.value=Comma(this.value);" onkeypress="return isNumber(event)" Visible="false"></asp:TextBox>

                                                            <asp:Panel ID="pnThoiGian" runat="server" Visible="false">
                                                                <asp:TextBox ID="txtNam" CssClass="user" Width="40px" runat="server"
                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                <span class='span_date'>năm&nbsp;&nbsp;</span>

                                                                <asp:TextBox ID="txtThang" CssClass="user" Width="40px" runat="server"
                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                <span class='span_date'>tháng&nbsp;&nbsp;</span>

                                                                <asp:TextBox ID="txtNgay" CssClass="user" Width="40px" runat="server"
                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                <span class='span_date'>ngày</span>
                                                            </asp:Panel>

                                                            <asp:Panel ID="pnKhac" runat="server" Visible="false">
                                                                <asp:TextBox ID="txtKhac1" CssClass="user" Width="100px" runat="server"
                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                hoặc
                                                                <asp:TextBox ID="txtKhac2" runat="server" CssClass="user" Width="100px" Text=""></asp:TextBox>
                                                            </asp:Panel>

                                                            <asp:CheckBox ID="chkAnTreo" runat="server" Text="Hưởng án treo" CssClass="margin_top" />
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></table></FooterTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                    <!------------------------------------------->
                                    <div class="boxchung">
                                        <h4 class="tleboxchung bg_title_group bg_green">
                                            <asp:Literal ID="lttNhomQDKhac" runat="server"></asp:Literal></h4>
                                        <div class="boder" style="padding: 20px 10px;">
                                            <asp:Repeater ID="rptQDKhac" runat="server" OnItemDataBound="rptHP_ItemDataBound">
                                                <HeaderTemplate>
                                                    <table style="width: 100%;" id="tblQuyetDinhKhac">
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <tr>

                                                        <td style="width: 35%;"><%# Eval("TenHinhPhat") %></td>
                                                        <td style="width: 50px;">
                                                            <div style="float: left; width: 100%; text-align: center;">
                                                                <asp:CheckBox ID="chk" ToolTip='<%#Eval("ID") %>' runat="server" AutoPostBack="true" />
                                                            </div>
                                                            <asp:HiddenField ID="hddGroup" runat="server" Value='<%#Eval("NHOMHINHPHAT") %>' />
                                                            <asp:HiddenField ID="hddLoai" runat="server" Value='<%#Eval("LoaiHinhPHat") %>' />
                                                            <asp:HiddenField ID="hddHinhPhatID" runat="server" Value='<%#Eval("ID") %>' />
                                                        </td>
                                                        <td>
                                                            <asp:RadioButtonList ID="rdDefaultTrue" runat="server"
                                                                RepeatDirection="Horizontal" Visible="false">
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                            <!-------------------------->
                                                            <asp:RadioButtonList ID="rdTrueFalse" runat="server"
                                                                RepeatDirection="Horizontal" Visible="false">
                                                                <asp:ListItem Value="0">Không</asp:ListItem>
                                                                <asp:ListItem Value="1">Có</asp:ListItem>
                                                            </asp:RadioButtonList>
                                                            <!-------------------------->
                                                            <asp:TextBox ID="txtSohoc" CssClass="user" Width="100px"
                                                                runat="server" onkeyup="javascript:this.value=Comma(this.value);" onkeypress="return isNumber(event)" Visible="false">
                                                            </asp:TextBox>
                                                            <!-------------------------->
                                                            <asp:Panel ID="pnThoiGian" runat="server" Visible="false">
                                                                <asp:TextBox ID="txtNam" CssClass="user" Width="40px" runat="server"
                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                <span class='span_date'>năm&nbsp;&nbsp;</span>
                                                                <asp:TextBox ID="txtThang" CssClass="user" Width="40px" runat="server"
                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                <span class='span_date'>tháng&nbsp;&nbsp;</span>
                                                                <asp:TextBox ID="txtNgay" CssClass="user" Width="40px" runat="server"
                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                <span class='span_date'>ngày</span>
                                                            </asp:Panel>
                                                            <!-------------------------->
                                                            <asp:Panel ID="pnKhac" runat="server" Visible="false">
                                                                <asp:TextBox ID="txtKhac1" CssClass="user" Width="100px" runat="server"
                                                                    Text="0" onkeypress="return isNumber(event)"></asp:TextBox>
                                                                hoặc
                                                                <asp:TextBox ID="txtKhac2" runat="server" CssClass="user"
                                                                    Width="100px" Text=""></asp:TextBox>
                                                            </asp:Panel>
                                                            <!-------------------------->

                                                            <asp:CheckBox ID="chkAnTreo" runat="server" Text="Hưởng án treo" CssClass="margin_top" />
                                                        </td>
                                                    </tr>
                                                </ItemTemplate>
                                                <FooterTemplate></table></FooterTemplate>
                                            </asp:Repeater>
                                        </div>
                                    </div>
                                    <!------------------------------------------>
                                    <div style="float: left; width: 100%; text-align: center;">
                                        <asp:Button ID="cmdSaveHinhPhat2" runat="server" CssClass="buttoninput"
                                            Text="Lưu hình phạt" OnClick="cmdSaveHinhPhat_Click" />
                                    </div>
                                </asp:Panel>
                            </div>

                        </div>
                    </div>
                </div>

                <div id="popupChonToiDanhChinh" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 20px; border: 2px solid #ccc; z-index: 1000; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); min-width: 700px;">
                    <div style="font-size: 16px; font-weight: bold; margin-bottom: 16px;">
                        Chọn tội danh chính
                    </div>

                    <asp:Repeater ID="dgToiDanhChinh" runat="server">
                        <HeaderTemplate>
                            <table class="table2" width="100%" border="1">
                                <tr class="header">
                                    <td width="42" align="center"><strong>STT</strong></td>
                                    <td width="150px" align="center"><strong>Bộ luật</strong></td>
                                    <td width="50px" align="center"><strong>Điều</strong></td>
                                    <td width="50px" align="center"><strong>Khoản</strong></td>
                                    <td width="50px" align="center"><strong>Điểm</strong></td>
                                    <td align="center"><strong>Tội danh</strong></td>
                                    <td width="60px" align="center"><strong>Là tội danh chính</strong></td>
                                </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td align="center"><%# Eval("STT") %></td>
                                <td><%# Eval("TenBoLuat") %></td>
                                <td><%# Eval("Dieu") %></td>
                                <td><%# Eval("Khoan") %></td>
                                <td><%# Eval("Diem") %></td>
                                <td><%# Eval("TENTOIDANH") %></td>
                                <td align="center">
                                    <asp:HiddenField ID="hddID_ToiDanh" runat="server" Value='<%# Eval("TOIDANHID") %>' />
                                    <asp:CheckBox ID="chkLuaChon" runat="server" InputAttributes-CssClass="chkLuaChon" Checked='<%# CheckToiDanh(Eval("ISMAIN")) %>' />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <div align="center">
                        <asp:Label runat="server" ID="lbThongBao_chonTDC" ForeColor="Red"></asp:Label><br />
                        <asp:Button ID="btnSaveTDC" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="btnSaveTDC_Click" OnClientClick="return validateToiDanh();" />
                        <input type="button" class="buttoninput" onclick="anPopup();" value="Đóng" />
                    </div>
                </div>
                <!-- Nền mờ khi hiển thị popup -->
                <div id="overlay" style="display: none; position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background-color: rgba(0, 0, 0, 0.5); /*  màu nền tối mờ */
    z-index: 999; /* dưới popup một lớp */">
                </div>
                <script type="text/javascript">
                    function hienPopup() {
                        document.getElementById("popupChonToiDanhChinh").style.display = "block";
                        document.getElementById("overlay").style.display = "block";
                    }

                    function anPopup() {
                        document.getElementById("popupChonToiDanhChinh").style.display = "none";
                        document.getElementById("overlay").style.display = "none";
                    }

                    function validateToiDanh() {
                        debugger;
                        var checkboxes = document.querySelectorAll("input[type='checkbox'][name*='chkLuaChon']:checked");
                        var count = checkboxes.length;
                        var label = document.getElementById("lbThongBao_chonTDC");

                        if (count === 0) {
                            label.innerText = "Bạn chưa chọn bản ghi nào!";
                            return false;
                        }
                        if (count > 1) {
                            label.innerText = "Chỉ được chọn 1 bản ghi là tội danh chính!";
                            return false;
                        }

                        return true;
                    }
                </script>
                <script type="text/javascript">
                    window.onunload = function () {
                        if (!window.fromChildReload) {
                            if (window.opener && !window.opener.closed) {
                                window.opener.location.reload();
                            }
                        }
                    };
                </script>
                <script>

                    function ValidateThemDL() {
                        var dropBoLuat = document.getElementById('<%=dropBoLuat.ClientID%>');
                        value_change = dropBoLuat.options[dropBoLuat.selectedIndex].value;
                        if (value_change == "0") {
                            alert('Bạn chưa chọn bộ luật. Hãy kiểm tra lại!');
                            dropBoLuat.focus();
                            return false;
                        }

                        var txtKhoan = document.getElementById('<%=txtKhoan.ClientID%>');
                        if (!Common_CheckEmpty(txtKhoan.value)) {
                            alert('Bạn chưa nhập mục "Khoản". Hãy kiểm tra lại!');
                            txtKhoan.focus();
                            return false;
                        }

                        var txtDieu = document.getElementById('<%=txtDieu.ClientID%>');
                        if (!Common_CheckEmpty(txtDieu.value)) {
                            alert('Bạn chưa nhập mục "Điều". Hãy kiểm tra lại!');
                            txtDieu.focus();
                            return false;
                        }
                        return true;
                    }

                </script>
                <script>
                    function pageLoad(sender, args) {
                        var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                        for (var selector in config) { $(selector).chosen(config[selector]); }
                    }
                    function popupChonToiDanh() {
                        var width_popup = 750;
                        var height_popup = 800;
                        var link = "/QLAN/AHS/PhucTham/BanAn/Popup/pChonToiDanh.aspx?aID=<%=BanAnID%>&bID=<%=BiCanID%>";
                        OpenPopup(link, "Chọn tội danh", width_popup, height_popup);
                    }
                    function OpenPopup(pageURL, title, w, h) {
                        var left = (screen.width / 2) - (w / 2);
                        var top = (screen.height / 2) - (h / 2);
                        var targetWin = window.open(pageURL, title, 'toolbar=yes,scrollbars=yes,resizable=yes,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
                        return targetWin;
                    }

                    function ChangeHP(hinhphatid, grouphp) {
                        // alert(hinhphatid +", "+ grouphp);
                        var hddGroupChange = document.getElementById('<%=hddGroupChange.ClientID%>');
                        var hdd = document.getElementById('<%=hddHinhPhatChange.ClientID%>');
                        var hdd_value = hdd.value;
                        if (hdd_value == hinhphatid) {
                            hdd.value = "0";
                            hddGroupChange.value = "0";
                        }
                        else {
                            hdd.value = hinhphatid;
                            hddGroupChange.value = grouphp;
                        }
                        //alert(hdd.value);
                    }

                    function ReloadParent() {
                        window.opener.parent.Loadds_bicao();
                    }
                </script>

            </ContentTemplate>
        </asp:UpdatePanel>


        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
            <ProgressTemplate>
                <div class="processmodal">
                    <div class="processcenter">
                        <img src="/UI/img/process.gif" />
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </form>
</body>
</html>
