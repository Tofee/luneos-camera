#include "pieslice.h"

#include <QRectF>
#include <QPainterPath>
#include <QPainter>
#include <QtCore/qmath.h>
#include <QRadialGradient>

MenuPieSlice::MenuPieSlice():
    mArcLength(30),
    mInnerRadius(50),
    mShadowRadius(5),
    mColor(QColor(238, 238, 238, 172))
{
}

double MenuPieSlice::arcLength() const
{
    return mArcLength;
}
double MenuPieSlice::innerRadius() const
{
    return mInnerRadius;
}
double MenuPieSlice::shadowRadius() const
{
    return mShadowRadius;
}

QColor MenuPieSlice::color() const
{
    return mColor;
}

void MenuPieSlice::setArcLength(double newArcLength)
{
    if(newArcLength != mArcLength) {
        mArcLength = newArcLength;
        emit arcLengthChanged();
    }
}
void MenuPieSlice::setInnerRadius(double newInnerRadius)
{
    if(newInnerRadius != mInnerRadius) {
        mInnerRadius = newInnerRadius;
        emit innerRadiusChanged();
    }
}
void MenuPieSlice::setShadowRadius(double newShadowRadius)
{
    if(newShadowRadius != mShadowRadius) {
        mShadowRadius = newShadowRadius;
        emit shadowRadiusChanged();
    }
}
void MenuPieSlice::setColor(QColor newColor)
{
    if(newColor != mColor) {
        mColor = newColor;
        emit colorChanged();
        update();
    }
}

void MenuPieSlice::paint(QPainter *painter)
{
    double lWidth = boundingRect().width();
    double lHeight = boundingRect().height();
    double ringWidthRatio = (lWidth-2*mInnerRadius)/lWidth;

    painter->setPen(Qt::NoPen);
    painter->setRenderHint(QPainter::Antialiasing);

    QRadialGradient radialGrad(QPointF(lWidth/2, lHeight/2), lWidth/2);
    radialGrad.setColorAt(0, Qt::transparent);
    radialGrad.setColorAt(1-2*ringWidthRatio, mColor);
    radialGrad.setColorAt(1, mColor.darker(110));

    // outer and inner washer dimensions
    QRectF outerRect(0, 0, lWidth, lHeight); outerRect.adjust(mShadowRadius, mShadowRadius, -mShadowRadius, -mShadowRadius);
    QRectF innerRect(lWidth*ringWidthRatio, lHeight*ringWidthRatio, lWidth*(1-2*ringWidthRatio), lHeight*(1-2*ringWidthRatio));

    //-------------- this is the essence of the matter -------------
    // create a path with two arcs to form the outline
    QPainterPath path;
    path.moveTo(lWidth-mShadowRadius, lHeight/2);
    path.arcTo(outerRect,0,-mArcLength);
    path.arcTo(innerRect,-mArcLength,mArcLength);
    //--------------------------------------------------------------

    // and finally fill it
    painter->fillPath(path, QBrush(radialGrad));
}
