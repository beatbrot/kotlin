/*
 * Copyright 2010-2021 JetBrains s.r.o. and Kotlin Programming Language contributors.
 * Use of this source code is governed by the Apache 2.0 license that can be found in the license/LICENSE.txt file.
 */

package org.jetbrains.kotlin.fir.analysis.checkers.expression

import org.jetbrains.kotlin.KtFakeSourceElementKind
import org.jetbrains.kotlin.KtRealSourceElementKind
import org.jetbrains.kotlin.descriptors.annotations.AnnotationUseSiteTarget
import org.jetbrains.kotlin.descriptors.annotations.KotlinTarget
import org.jetbrains.kotlin.fir.analysis.checkers.checkRepeatedAnnotation
import org.jetbrains.kotlin.fir.analysis.checkers.context.CheckerContext
import org.jetbrains.kotlin.fir.analysis.checkers.getAllowedAnnotationTargets
import org.jetbrains.kotlin.fir.analysis.checkers.getDefaultUseSiteTarget
import org.jetbrains.kotlin.diagnostics.DiagnosticReporter
import org.jetbrains.kotlin.fir.analysis.diagnostics.FirErrors
import org.jetbrains.kotlin.diagnostics.reportOn
import org.jetbrains.kotlin.fir.declarations.FirDeclaration
import org.jetbrains.kotlin.fir.expressions.*
import org.jetbrains.kotlin.fir.types.ConeKotlinType
import org.jetbrains.kotlin.fir.types.coneType

object FirExpressionAnnotationChecker : FirBasicExpressionChecker() {
    override fun check(expression: FirStatement, context: CheckerContext, reporter: DiagnosticReporter) {
        // Declarations are checked separately
        // See KT-33658 about annotations on non-expression statements
        if (expression is FirDeclaration ||
            expression !is FirExpression ||
            expression is FirErrorExpression
        ) return

        val annotations = expression.annotations
        if (annotations.isEmpty()) return

        val annotationsMap = hashMapOf<ConeKotlinType, MutableList<AnnotationUseSiteTarget?>>()
        val alwaysCorrectTarget = isTargetAlwaysCorrect(expression)

        for (annotation in annotations) {
            val useSiteTarget = annotation.useSiteTarget ?: expression.getDefaultUseSiteTarget(annotation, context)
            val existingTargetsForAnnotation = annotationsMap.getOrPut(annotation.annotationTypeRef.coneType) { arrayListOf() }

            if (!alwaysCorrectTarget && KotlinTarget.EXPRESSION !in annotation.getAllowedAnnotationTargets(context.session)) {
                reporter.reportOn(annotation.source, FirErrors.WRONG_ANNOTATION_TARGET, "expression", context)
            }

            checkRepeatedAnnotation(useSiteTarget, existingTargetsForAnnotation, annotation, context, reporter)

            existingTargetsForAnnotation.add(useSiteTarget)
        }
    }

    private fun isTargetAlwaysCorrect(expression: FirStatement): Boolean {
        if (expression is FirBlock &&
            (expression.source?.kind?.let { it == KtRealSourceElementKind || it == KtFakeSourceElementKind.DesugaredForLoop } == true)
        ) {
            return true
        }

        return expression is FirWhenExpression && !expression.usedAsExpression
    }
}
