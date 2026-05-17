<%--Màn thêm mới thống kê quá hạn--%>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pThemTKQuaHan.aspx.cs" Inherits="WEB.GSTP.QLAN.AKT.Hoso.Popup.pThemTKQuaHan" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thống kê quá hạn</title>
    <link href="../../../../UI/css/style.css" rel="stylesheet" />
    <link href="../../../../UI/img/spcLogo.png" type="image/png" rel="shortcut icon" />
    <link href="../../../../UI/css/chosen.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery.enhsplitter.css" rel="stylesheet" />
    <link href="../../../../UI/css/jquery-ui.css" rel="stylesheet" />
    <script src="../../../../UI/js/jquery-3.3.1.js"></script>
    <script src="../../../../UI/js/jquery-ui.min.js"></script>
    <script src="../../../../UI/js/Common.js"></script>
    <script src="../../../../UI/js/chosen.jquery.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <style>
            body {
                width: 98%;
                margin-left: 1%;
                min-width: 0px;
                overflow: auto;
            }

            .cssMargin {
                margin-bottom: 30px;
            }

            .boxchung {
                margin: 5px 10px;
                width: 100%;
                position: relative;
            }

            .btnChon {
                float: right;
                margin-left: 8px;
            }

            .btnKhongCovuQuaHan {
                float: right;
                width: 160px;
                height: 30px;
                line-height: 30px;
                background-color: #db212d;
                color: white;
                text-align: center;
                font-size: 12px;
                font-weight: bold;
                border: none;
                border-radius: 3px;
                cursor: pointer;
                box-shadow: 0 2px 6px rgba(0,0,0,0.2);
                transition: background-color 0.3s ease, transform 0.2s ease;
            }

            .link-disabled {
                pointer-events: none;
                opacity: 0.5;
                cursor: not-allowed;
            }


            .dropStyle {
                padding: 10px 14px;
                border: 1px solid #d0d0d0;
                border-radius: 8px;
                background-color: #fff;
                font-size: 14px;
                font-family: Arial, sans-serif;
                color: #333;
                cursor: pointer;
                outline: none;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                transition: all 0.2s ease;
            }

                .dropStyle:hover {
                    border-color: #999;
                    box-shadow: 0 3px 6px rgba(0,0,0,0.15);
                }

                .dropStyle:focus {
                    border-color: #3f51b5;
                    box-shadow: 0 0 0 3px rgba(63,81,181,0.2);
                }

            .tleboxchung {
                position: absolute;
                margin-left: 15px;
                background: #ffe869;
                z-index: 2;
                padding: 0 2px;
                white-space: nowrap;
                border: solid 1px #dcdcdc;
                padding: 5px 10px;
                border-radius: 10px;
                font-weight: bold;
                text-transform: uppercase;
            }

            .box_nd::after {
                content: "";
                display: block;
                clear: both;
            }
        </style>
        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />

        <div class="boxchung">
            <div style="float: left; width: 120px; height: 39px; font-size: 16px; text-align: right; margin: 10px 10px;">Năm <span class="batbuoc">(*)</span></div>
            <div style="float: left;">
                <asp:DropDownList ID="dropNam" CssClass="dropStyle" runat="server" Width="248px" AutoPostBack="true" OnSelectedIndexChanged="dropNam_OnSelectedIndexChanged">
                </asp:DropDownList>
            </div>
            <div style="float: left; width: 120px; height: 39px; font-size: 16px; text-align: right; margin: 10px 10px;">Tháng <span class="batbuoc">(*)</span></div>
            <div style="float: left;">
                <asp:DropDownList ID="dropThang" CssClass="dropStyle" runat="server" Width="248px" onchange="updateBtnKhongCoVuQuaHan();" AutoPostBack="true" OnSelectedIndexChanged="dropThang_OnSelectedIndexChanged">
                </asp:DropDownList>
            </div>

        </div>

        <table class="table1">
            <tr>
                <td colspan="2">
                    <div class="boxchung">
                        <h4 class="tleboxchung">Tìm kiếm</h4>
                        <div class="boder" style="padding: 10px;">
                            <table class="table1">
                                <tr>
                                    <td>
                                        <div class="box_nd">
                                            <div style="float: left; width: 1050px">

                                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên vụ án</div>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                </div>
                                                <div style="float: left; width: 90px; text-align: right; margin-right: 10px;">Quan hệ pháp luật</div>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txt_QHPL" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                </div>
                                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Cấp xét xử</div>
                                                <div style="float: left;">
                                                    <asp:DropDownList ID="dropCapxx" CssClass="chosen-select" runat="server" Width="250px"
                                                        AutoPostBack="True">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="box_nd">
                                            <div style="float: left; width: 1050px">

                                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Đương sự</div>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtTENDUONGSU" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                </div>
                                                <div style="float: left; width: 90px; text-align: right; margin-right: 10px;">Số thụ lý</div>
                                                <div style="float: left;">
                                                    <asp:TextBox ID="txtSOTHULY_THONGBAO" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                </div>
                                                <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thẩm phán</div>
                                                <div style="float: left;">
                                                    <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px" AutoPostBack="True"></asp:DropDownList>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                    <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                    <asp:Button ID="cmdChonVV" runat="server" CssClass="buttoninput btnChon" Text="Chọn" OnClick="cmdChonVV_Click" />
                    <asp:LinkButton ID="btnKhongCovuQuaHan" runat="server" class="btnKhongCovuQuaHan" OnClick="btnKhongCovuQuaHan_Click" Visible="true">Không có vụ việc quá hạn</asp:LinkButton>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="left">
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                OnClick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                OnClick="lbTNext_Click"></asp:LinkButton>
                            <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div>
                        <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound">
                            <Columns>
                                <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                <asp:TemplateColumn HeaderStyle-Width="20px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>Chọn</HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("ID")%>' runat="server" onchange="updateBtnKhongCoVuQuaHan();" />
                                        <asp:HiddenField ID="hdID" runat="server" Value='<%# Eval("ID") %>' />
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Mã vụ việc
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("MAVUVIEC")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                    <HeaderTemplate>
                                        Thông tin vụ việc
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <i style='margin-right: 3px;'>Vụ việc:</i>  <b><%#Eval("TENVUVIEC")%></b>
                                        <br />
                                        <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("GiaiDoanVuViec")%></b>
                                        <%#Eval("TruongHopGiaoNhan")%>
                                        <%# Eval("TENTOASOTHAM")%>
                                        <%#Eval("BANAN_QD_ST")%>
                                        <%#Eval("HoTenBiCan")%>
                                        <%#Eval("KHANGNGHI_ST")%>
                                        <asp:HiddenField ID="hddCHECK_THULY" runat="server" Value='<%#Eval("CHECK_THULY")%>' />
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="200px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                    <HeaderTemplate>
                                        Tình trạng giải quyết
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("TINHTRANG_GQ")%>
                                        <%#Eval("QD_PT")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="150px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                    <HeaderTemplate>
                                        Người tạo
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("NGUOITAO")%>
                                        <br />
                                        <%#Eval("NGAYTAO")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                            </Columns>
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                        </asp:DataGrid>
                    </div>
                    <div class="phantrang">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                OnClick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="true"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                OnClick="lbTNext_Click"></asp:LinkButton>
                            <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                <asp:ListItem Value="500" Text="500"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <hr style="border: none; border-top: 1px solid #000;">
        <br />
        <asp:Panel ID="pnlTitle" runat="server"
            Style="margin-left: 6px;" Font-Size="16px">
            Danh sách vụ việc thống kê quá hạn
        </asp:Panel>

        <table class="table1">
            <tr>
                <td colspan="2" align="left">
                    <div style="text-align: center">
                        <asp:DataGrid ID="dgListCon" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                            ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgListCon_ItemDataBound" OnItemCommand="dgListCon_ItemCommand">
                            <Columns>
                                <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                <asp:BoundColumn DataField="GiaiDoanVuViec" Visible="false"></asp:BoundColumn>
                                <asp:BoundColumn DataField="MAVUVIEC" Visible="false"></asp:BoundColumn>
                                <asp:BoundColumn DataField="TENVUVIEC" Visible="false"></asp:BoundColumn>
                                <asp:TemplateColumn HeaderStyle-Width="15px">
                                    <HeaderTemplate>STT</HeaderTemplate>
                                    <ItemTemplate>
                                        <%# (Container.ItemIndex + 1) + (dgListCon.PageSize * dgListCon.CurrentPageIndex) %>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Mã vụ việc
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("MAVUVIEC")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                    <HeaderTemplate>
                                        Thông tin vụ việc
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <i style='margin-right: 3px;'>Vụ việc:</i>  <b><%#Eval("TENVUVIEC")%></b>
                                        <br />
                                        <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("GiaiDoanVuViec")%></b>
                                        <%#Eval("TruongHopGiaoNhan")%>
                                        <%# Eval("TENTOASOTHAM")%>
                                        <%#Eval("BANAN_QD_ST")%>
                                        <%#Eval("HoTenBiCan")%>
                                        <%#Eval("KHANGNGHI_ST")%>
                                        <asp:HiddenField ID="hddCHECK_THULY" runat="server" Value='<%#Eval("CHECK_THULY")%>' />
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="180px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                    <HeaderTemplate>
                                        Tình trạng giải quyết
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("TINHTRANG_GQ")%>
                                        <%#Eval("QD_PT")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                    <HeaderTemplate>
                                        Người tạo
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <%#Eval("NGUOITAO")%>
                                        <br />
                                        <%#Eval("NGAYTAO")%>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="120px">
                                    <HeaderTemplate>
                                        Lý do quá hạn
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:DropDownList ID="dropLyDo" runat="server" Width="110px" CssClass="so">
                                            <asp:ListItem Value="1" Text="Chủ quan" Selected="True"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Khách quan"></asp:ListItem>
                                        </asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="160px">
                                    <HeaderTemplate>
                                        Chi tiết
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:TextBox TextMode="MultiLine" ID="ChiTiet_LyDo" runat="server" CssClass="textbox" Wrap="true" Height="50px" Width="160px" oninput="if(this.value.length > 100) this.value = this.value.substring(0, 100);"></asp:TextBox>
                                    </ItemTemplate>
                                </asp:TemplateColumn>
                                <asp:TemplateColumn HeaderStyle-Width="60px"
                                    HeaderStyle-HorizontalAlign="Center"
                                    ItemStyle-HorizontalAlign="Center">
                                    <HeaderTemplate>
                                        Thao tác
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="btnXoa"
                                            runat="server"
                                            Text="Xóa"
                                            ForeColor="Red"
                                            CommandName="XOA"
                                            CommandArgument='<%# Eval("ID") %>'
                                            OnClientClick="return confirm('Xóa vụ việc này khỏi danh sách?');" />
                                    </ItemTemplate>
                                </asp:TemplateColumn>

                            </Columns>
                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                        </asp:DataGrid>
                    </div>
                </td>
            </tr>

            <tr>
                <td align="center" colspan="2">
                    <asp:Label runat="server" ID="lbKhongCoVu" ForeColor="Red" Font-Size="16px" Font-Italic="true" Visible="false">Không có vụ việc quá hạn</asp:Label>
                    <asp:Button ID="btnLuu" runat="server" CssClass="buttoninput" Text="Lưu thống kê" OnClick="cmdLuu_Click" />
                </td>
            </tr>
        </table>
        <%--        <asp:HiddenField ID="hfShowPopup" runat="server" />--%>
        <%--<div id="popupNhapThongTin" runat="server" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 20px; border: 2px solid #ccc; z-index: 1000; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); min-width: 95%; min-height: 95%">
            <div style="font-size: 16px; font-weight: bold; margin-bottom: 16px;">
                <asp:Literal ID="ltTitle" runat="server"></asp:Literal>
            </div>

            <div class="boxchung">

                <div style="float: left; width: 120px; height: 39px; font-size: 16px; text-align: left; margin: 10px 10px;">Kỳ thống kê</div>
                <div style="float: left;">
                    <asp:DropDownList ID="dropKyThongKe_child" CssClass="dropStyle chosen-select" runat="server" Width="248px" AutoPostBack="True" Disabled="true">
                    </asp:DropDownList>
                </div>
            </div>

            <table class="table1">
                <tr>
                    <td colspan="2" align="left">
                        <div style="text-align: center">
                            <asp:DataGrid ID="dgListCon" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="false" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgListCon_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="GiaiDoanVuViec" Visible="false"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="MAVUVIEC" Visible="false"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="TENVUVIEC" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="15px">
                                        <HeaderTemplate>STT</HeaderTemplate>
                                        <ItemTemplate>
                                            <%# (Container.ItemIndex + 1) + (dgListCon.PageSize * dgListCon.CurrentPageIndex) %>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Mã vụ việc
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("MAVUVIEC")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                            Thông tin vụ việc
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <i style='margin-right: 3px;'>Vụ việc:</i>  <b><%#Eval("TENVUVIEC")%></b>
                                            <br />
                                            <i style='margin-right: 3px;'>Cấp xét xử:</i>  <b><%#Eval("GiaiDoanVuViec")%></b>
                                            <%#Eval("TruongHopGiaoNhan")%>
                                            <%# Eval("TENTOASOTHAM")%>
                                            <%#Eval("BANAN_QD_ST")%>
                                            <%#Eval("HoTenBiCan")%>
                                            <%#Eval("KHANGNGHI_ST")%>
                                            <asp:HiddenField ID="hddCHECK_THULY" runat="server" Value='<%#Eval("CHECK_THULY")%>' />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="180px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                            Tình trạng giải quyết
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("TINHTRANG_GQ")%>
                                            <%#Eval("QD_PT")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                        <HeaderTemplate>
                                            Người tạo
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("NGUOITAO")%>
                                            <br />
                                            <%#Eval("NGAYTAO")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="120px">
                                        <HeaderTemplate>
                                            Lý do quá hạn
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:DropDownList ID="dropLyDo" runat="server" Width="110px" CssClass="so">
                                                <asp:ListItem Value="1" Text="Chủ quan" Selected="True"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Khách quan"></asp:ListItem>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="160px">
                                        <HeaderTemplate>
                                            Chi tiết
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox TextMode="MultiLine" ID="ChiTiet_LyDo" runat="server" CssClass="textbox" Wrap="true" Height="50px" Width="160px" oninput="if(this.value.length > 100) this.value = this.value.substring(0, 100);"></asp:TextBox>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                        </div>                
                    </td>
                </tr>

                <tr>
                    <td align="center" colspan="2">
                        <asp:Button ID="cmdLuu" runat="server" CssClass="buttoninput" Text="Lưu" OnClick="cmdLuu_Click" />
                        <asp:Button ID="cmdDong" runat="server" CssClass="buttoninput" Text="Đóng" OnClick="cmdDong_Click" />
                    </td>
                </tr>
            </table>
        </div>--%>
        <script type="text/javascript">

            function OnClose() {
                //Gọi đến function của windown parent
                if (window.opener != null && !window.opener.closed) {
                    window.opener.HideModalDivTKQuaHan();
                }
                window.close();
            }

            function OnClose_Sua() {
                //Gọi đến function của windown parent
                if (window.opener != null && !window.opener.closed) {
                    window.opener.HideModalDivTKQuaHan_Sua();
                }
                window.close();
            }

            //Khi đóng popup
            $(window).on("beforeunload", function () {
                return window.opener.hideOverlay();
            })

            function xoaDong(el) {
                if (!confirm("Bạn có chắc muốn xóa dòng này trên giao diện?"))
                    return false;

                // el = thẻ <a>
                var row = el.closest("tr");
                if (row) {
                    row.style.display = "none";
                }

                return false;
            }


            function pageLoad(sender, args) {
                var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
                for (var selector in config) { $(selector).chosen(config[selector]); }
            }

            function updateBtnKhongCoVuQuaHan() {
                var anyChecked = false;
                document.querySelectorAll('input[type="checkbox"][id*="chkChon"]').forEach(function (cb) {
                    if (cb.checked) anyChecked = true;
                });

                var dropThang = document.getElementById('<%= dropThang.ClientID %>');
                var thangChuaChon = !dropThang || !dropThang.value || dropThang.value === "" || dropThang.value === "0";

                var disable = anyChecked || thangChuaChon;

                var btn = document.getElementById('<%= btnKhongCovuQuaHan.ClientID %>');
                if (!btn) return;

                if (disable) {
                    btn.classList.add('link-disabled');
                } else {
                    btn.classList.remove('link-disabled');
                }

            }

            // chạy khi load form lần đầu
            document.addEventListener("DOMContentLoaded", updateBtnKhongCoVuQuaHan);
        </script>
    </form>
</body>
</html>
